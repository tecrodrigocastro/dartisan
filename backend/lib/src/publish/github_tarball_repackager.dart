import 'package:archive/archive.dart';

/// Reempacota o tarball que o GitHub devolve (`GET .../tarball/{ref}`) pro
/// formato que o `dart pub` espera: o GitHub sempre embrulha tudo num único
/// diretório raiz (`owner-repo-sha/arquivo`), mas o pub espera os arquivos na
/// raiz do tar (`arquivo`) — sem isso, `PublishValidator` nunca acha o
/// `pubspec.yaml` (`Archive.findFile` faz match exato de nome, não sufixo).
List<int> repackageGithubTarball(List<int> githubTarballBytes) {
  final tarBytes = GZipDecoder().decodeBytes(githubTarballBytes);
  final archive = TarDecoder().decodeBytes(tarBytes);

  final prefix = _commonPrefix(archive.files.map((f) => f.name));

  final repackaged = Archive();
  for (final file in archive.files) {
    if (!file.isFile) continue;
    final strippedName = prefix.isEmpty ? file.name : file.name.substring(prefix.length);
    if (strippedName.isEmpty) continue;

    final content = file.content as List<int>;
    repackaged.addFile(ArchiveFile(strippedName, content.length, content));
  }

  final repackagedTar = TarEncoder().encode(repackaged);
  return GZipEncoder().encode(repackagedTar)!;
}

/// Prefixo comum de diretório raiz (com a barra), ou string vazia se os
/// arquivos não estiverem todos sob um único diretório.
String _commonPrefix(Iterable<String> names) {
  if (names.isEmpty) return '';
  final first = names.first;
  final slash = first.indexOf('/');
  if (slash == -1) return '';

  final candidate = first.substring(0, slash + 1);
  return names.every((name) => name.startsWith(candidate)) ? candidate : '';
}
