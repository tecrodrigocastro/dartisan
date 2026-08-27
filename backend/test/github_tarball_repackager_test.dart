import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:backend/src/publish/github_tarball_repackager.dart';
import 'package:test/test.dart';

List<int> buildTarball(Map<String, String> files) {
  final archive = Archive();
  files.forEach((name, content) {
    final bytes = utf8.encode(content);
    archive.addFile(ArchiveFile(name, bytes.length, bytes));
  });
  return GZipEncoder().encode(TarEncoder().encode(archive))!;
}

Map<String, String> readTarball(List<int> tarballBytes) {
  final tarBytes = GZipDecoder().decodeBytes(tarballBytes);
  final archive = TarDecoder().decodeBytes(tarBytes);
  return {
    for (final file in archive.files)
      if (file.isFile) file.name: utf8.decode(file.content as List<int>),
  };
}

void main() {
  test('remove o prefixo owner-repo-sha/ que o GitHub sempre adiciona', () {
    final githubTarball = buildTarball({
      'dartisan-meu_pacote-abc123/pubspec.yaml': 'name: meu_pacote\nversion: 1.0.0\n',
      'dartisan-meu_pacote-abc123/lib/meu_pacote.dart': 'void main() {}',
    });

    final repackaged = repackageGithubTarball(githubTarball);
    final files = readTarball(repackaged);

    expect(files.keys, containsAll(['pubspec.yaml', 'lib/meu_pacote.dart']));
    expect(files.keys, isNot(contains('dartisan-meu_pacote-abc123/pubspec.yaml')));
    expect(files['pubspec.yaml'], 'name: meu_pacote\nversion: 1.0.0\n');
  });

  test('não mexe em tarball sem prefixo de diretório comum', () {
    final tarball = buildTarball({'pubspec.yaml': 'name: meu_pacote\nversion: 1.0.0\n'});

    final repackaged = repackageGithubTarball(tarball);
    final files = readTarball(repackaged);

    expect(files.keys, contains('pubspec.yaml'));
  });
}
