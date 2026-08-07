class PackageVersion {
  final String version;
  final String archiveUrl;
  final String archiveSha256;
  final Map<String, dynamic> pubspec;
  final String? uploadedBy;

  const PackageVersion({
    required this.version,
    required this.archiveUrl,
    required this.archiveSha256,
    required this.pubspec,
    required this.uploadedBy,
  });

  factory PackageVersion.fromJson(Map<String, dynamic> json) => PackageVersion(
    version: json['version'] as String,
    archiveUrl: json['archive_url'] as String,
    archiveSha256: json['archive_sha256'] as String,
    pubspec: (json['pubspec'] as Map).cast<String, dynamic>(),
    uploadedBy: json['uploaded_by'] as String?,
  );
}

/// Resumo de pacote — usado tanto na listagem pública quanto em "meus
/// pacotes". Mesmo shape do `PackageSummaryDTO` do backend.
class PackageSummary {
  final String name;
  final String latestVersion;
  final DateTime createdAt;

  const PackageSummary({
    required this.name,
    required this.latestVersion,
    required this.createdAt,
  });

  factory PackageSummary.fromJson(Map<String, dynamic> json) => PackageSummary(
    name: json['name'] as String,
    latestVersion: json['latest_version'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}

class PackageList {
  final List<PackageSummary> packages;
  final int total;

  const PackageList({required this.packages, required this.total});

  factory PackageList.fromJson(Map<String, dynamic> json) => PackageList(
    packages: (json['packages'] as List)
        .map((p) => PackageSummary.fromJson(p as Map<String, dynamic>))
        .toList(),
    total: json['total'] as int,
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
