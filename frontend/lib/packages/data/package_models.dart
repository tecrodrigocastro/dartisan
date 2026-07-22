class PackageVersion {
  final String version;
  final String archiveUrl;
  final String archiveSha256;
  final Map<String, dynamic> pubspec;

  const PackageVersion({
    required this.version,
    required this.archiveUrl,
    required this.archiveSha256,
    required this.pubspec,
  });

  factory PackageVersion.fromJson(Map<String, dynamic> json) => PackageVersion(
    version: json['version'] as String,
    archiveUrl: json['archive_url'] as String,
    archiveSha256: json['archive_sha256'] as String,
    pubspec: (json['pubspec'] as Map).cast<String, dynamic>(),
  );
}

class PackageMetadata {
  final String name;
  final PackageVersion latest;
  final List<PackageVersion> versions;

  const PackageMetadata({
    required this.name,
    required this.latest,
    required this.versions,
  });

  factory PackageMetadata.fromJson(Map<String, dynamic> json) => PackageMetadata(
    name: json['name'] as String,
    latest: PackageVersion.fromJson(json['latest'] as Map<String, dynamic>),
    versions: (json['versions'] as List)
        .map((v) => PackageVersion.fromJson(v as Map<String, dynamic>))
        .toList(),
  );
}
