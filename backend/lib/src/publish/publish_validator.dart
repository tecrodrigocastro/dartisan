import 'dart:convert';

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

@Component()
class PublishValidator {
  final PackageRepository _repository;

  PublishValidator(this._repository);

  Future<PublishArtifact> validate({
    required List<int> tarballBytes,
    required int maxSizeBytes,
  }) async {
    if (tarballBytes.length > maxSizeBytes) {
      _fail(
        'tarball_too_large',
        'Tarball excede o tamanho máximo permitido ($maxSizeBytes bytes)',
      );
    }

    final pubspecYaml = _extractPubspecYaml(tarballBytes);

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
    final versionString = pubspec.version.value;

    try {
      semver.Version.parse(versionString);
    } on FormatException {
      _fail('invalid_version', '"$versionString" não é um semver válido');
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

  String _extractPubspecYaml(List<int> tarballBytes) {
    final Archive archive;
    try {
      final tarBytes = GZipDecoder().decodeBytes(tarballBytes);
      archive = TarDecoder().decodeBytes(tarBytes);
    } catch (_) {
      _fail('invalid_archive', 'Não foi possível ler o tarball (.tar.gz)');
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
