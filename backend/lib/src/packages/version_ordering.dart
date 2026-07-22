import 'package:pub_semver/pub_semver.dart';

/// Ordena strings de versão por semver real (não lexicográfico) — usado
/// tanto pelos metadados (item 1) quanto pelo publish (item 3), pra manter
/// a mesma regra de "o que é a latest" nos dois lugares.
List<String> sortVersions(List<String> versions) {
  final sorted = [...versions]
    ..sort((a, b) => Version.parse(a).compareTo(Version.parse(b)));
  return sorted;
}

/// Maior versão estável entre [versions]; se só houver pre-release, a maior
/// pre-release. Assume que [versions] já está ordenado (ver [sortVersions]).
String pickLatestVersion(List<String> sortedVersions) {
  final stable = sortedVersions.where(
    (v) => !Version.parse(v).isPreRelease,
  );
  return stable.isNotEmpty ? stable.last : sortedVersions.last;
}
