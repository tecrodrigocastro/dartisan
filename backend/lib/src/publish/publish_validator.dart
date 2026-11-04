import 'dart:convert';
import 'dart:io';
import 'dart:typed_data' show BytesBuilder;

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:pub_semver/pub_semver.dart' as semver;
import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:vaden/vaden.dart';

import '../packages/package_repository.dart';

class PublishArtifact {
  final String packageName;
  final String version;
  final String pubspecYaml;
  final String archiveSha256;

  const PublishArtifact({
    required this.packageName,
    required this.version,
    required this.pubspecYaml,
    required this.archiveSha256,
  });
}

/// Mesmo teto do pub.dev para o conteúdo descompactado (256 MiB).
const defaultMaxUncompressedBytes = 256 * 1024 * 1024;

class _ArchiveTooLarge implements Exception {
  const _ArchiveTooLarge();
}

final _packageNamePattern = RegExp(r'^[a-z_][a-z0-9_]*$');

@Component()
class PublishValidator {
  final PackageRepository _repository;

  PublishValidator(this._repository);

  Future<PublishArtifact> validate({
    required List<int> tarballBytes,
    required int maxSizeBytes,
    required int actorUserId,
    required String actorRole,
    int maxUncompressedBytes = defaultMaxUncompressedBytes,
  }) async {
    if (tarballBytes.length > maxSizeBytes) {
      _fail(
        'tarball_too_large',
        'Tarball excede o tamanho máximo permitido ($maxSizeBytes bytes)',
      );
    }

    final pubspecYaml = await _extractPubspecYaml(
      tarballBytes,
      maxUncompressedBytes,
    );

    final PubSpec pubspec;
    try {
      pubspec = PubSpec.loadFromString(pubspecYaml);
    } catch (_) {
      _fail('invalid_pubspec', 'pubspec.yaml inválido ou malformado');
    }

    if (pubspec.name.missing || pubspec.name.value.trim().isEmpty) {
      _fail('invalid_pubspec', 'pubspec.yaml não tem "name"');
    }
    if (pubspec.version.missing || pubspec.version.value.trim().isEmpty) {
      _fail('invalid_pubspec', 'pubspec.yaml não tem "version"');
    }

    final packageName = pubspec.name.value;
    // O nome vira diretório no storage ({nome}/{versão}.tar.gz): sem essa
    // validação, "../../x" escaparia da pasta de storage (path traversal).
    if (!_packageNamePattern.hasMatch(packageName)) {
      _fail(
        'invalid_package_name',
        '"$packageName" não é um nome de pacote válido — use apenas letras '
            'minúsculas, números e underscore, sem começar por número',
      );
    }
    final versionString = pubspec.version.value;

    try {
      semver.Version.parse(versionString);
    } on FormatException {
      _fail('invalid_version', '"$versionString" não é um semver válido');
    }

    // Só o dono (quem publicou a primeira versão) ou um admin publica novas
    // versões de um pacote existente.
    if (actorRole != 'admin' &&
        await _repository.findByName(packageName) != null) {
      final owner = await _repository.findOwnerUserId(packageName);
      if (owner != actorUserId) {
        throw ResponseException(403, {
          'error': {
            'code': 'not_package_owner',
            'message': 'Você não é dono do pacote $packageName',
          },
        });
      }
    }

    final existing = await _repository.findVersion(packageName, versionString);
    if (existing != null) {
      _fail(
        'version_exists',
        'Versão $versionString de $packageName já foi publicada — '
            'pacotes são imutáveis por versão',
      );
    }

    return PublishArtifact(
      packageName: packageName,
      version: versionString,
      pubspecYaml: pubspecYaml,
      archiveSha256: sha256.convert(tarballBytes).toString(),
    );
  }

  Future<String> _extractPubspecYaml(
    List<int> tarballBytes,
    int maxUncompressedBytes,
  ) async {
    // Descompacta em streaming com teto: um .tar.gz pequeno pode expandir
    // para gigabytes (zip bomb), então não dá pra usar decodeBytes direto.
    final tarBytes = BytesBuilder(copy: false);
    try {
      await for (final chunk in gzip.decoder.bind(Stream.value(tarballBytes))) {
        tarBytes.add(chunk);
        if (tarBytes.length > maxUncompressedBytes) {
          throw const _ArchiveTooLarge();
        }
      }
    } on _ArchiveTooLarge {
      _fail(
        'archive_too_large',
        'Conteúdo descompactado excede o limite de $maxUncompressedBytes bytes',
      );
    } catch (_) {
      _fail('invalid_archive', 'Não foi possível ler o tarball (.tar.gz)');
    }

    final Archive archive;
    try {
      archive = TarDecoder().decodeBytes(tarBytes.takeBytes());
    } catch (_) {
      _fail('invalid_archive', 'Não foi possível ler o tarball (.tar.gz)');
    }

    for (final entry in archive) {
      final name = entry.name;
      final unsafe =
          name.startsWith('/') ||
          name.contains('\\') ||
          name.split('/').any((segment) => segment == '..');
      if (unsafe) {
        _fail('unsafe_archive_entry', 'Entrada inválida no tarball: "$name"');
      }
      if (entry.isSymbolicLink) {
        _fail(
          'unsafe_archive_entry',
          'Tarball não pode conter links simbólicos: "$name"',
        );
      }
    }

    final pubspecFile = archive.findFile('pubspec.yaml');
    if (pubspecFile == null) {
      _fail('invalid_archive', 'Tarball não contém pubspec.yaml na raiz');
    }

    return utf8.decode(pubspecFile.content as List<int>);
  }

  Never _fail(String code, String message) {
    throw ResponseException.badRequest({
      'error': {'code': code, 'message': message},
    });
  }
}
