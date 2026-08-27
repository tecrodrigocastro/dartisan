import 'package:vaden/vaden.dart';

@DTO()
class PackageVersionDTO {
  final String version;

  @JsonKey('archive_url')
  final String archiveUrl;

  @JsonKey('archive_sha256')
  final String archiveSha256;

  final Map<String, dynamic> pubspec;

  @JsonKey('uploaded_by')
  final String? uploadedBy;

  PackageVersionDTO({
    required this.version,
    required this.archiveUrl,
    required this.archiveSha256,
    required this.pubspec,
    required this.uploadedBy,
  });
}

@DTO()
class DownloadDayDTO {
  final String date;
  final int count;

  DownloadDayDTO({required this.date, required this.count});
}

@DTO()
class PackageMetadataDTO {
  final String name;
  final PackageVersionDTO latest;
  final List<PackageVersionDTO> versions;

  @JsonKey('like_count')
  final int likeCount;

  @JsonKey('downloads_total')
  final int downloadsTotal;

  @JsonKey('downloads_daily')
  final List<DownloadDayDTO> downloadsDaily;

  PackageMetadataDTO({
    required this.name,
    required this.latest,
    required this.versions,
    required this.likeCount,
    required this.downloadsTotal,
    required this.downloadsDaily,
  });
}

/// Resumo de pacote — usado tanto na listagem pública (`GET /api/packages`)
/// quanto em "meus pacotes" (`GET /api/me/packages`). Não carrega
/// pubspec/versões completas, isso já é servido por [PackageMetadataDTO].
@DTO()
class PackageSummaryDTO {
  final String name;

  @JsonKey('latest_version')
  final String latestVersion;

  @JsonKey('created_at')
  final DateTime createdAt;

  PackageSummaryDTO({
    required this.name,
    required this.latestVersion,
    required this.createdAt,
  });
}

@DTO()
class PackageListDTO {
  final List<PackageSummaryDTO> packages;
  final int total;

  PackageListDTO({required this.packages, required this.total});
}
