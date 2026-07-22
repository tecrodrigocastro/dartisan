import 'package:vaden/vaden.dart';

@DTO()
class PackageVersionDTO {
  final String version;

  @JsonKey('archive_url')
  final String archiveUrl;

  @JsonKey('archive_sha256')
  final String archiveSha256;

  final Map<String, dynamic> pubspec;

  PackageVersionDTO({
    required this.version,
    required this.archiveUrl,
    required this.archiveSha256,
    required this.pubspec,
  });
}

@DTO()
class PackageMetadataDTO {
  final String name;
  final PackageVersionDTO latest;
  final List<PackageVersionDTO> versions;

  PackageMetadataDTO({
    required this.name,
    required this.latest,
    required this.versions,
  });
}
