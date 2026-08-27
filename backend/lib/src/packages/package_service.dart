import 'dart:async';

import 'package:vaden/vaden.dart';
import 'package:yaml/yaml.dart';

import '../../config/drift/app_database.dart';
import 'package_dto.dart';
import 'package_download_repository.dart';
import 'package_like_repository.dart';
import 'package_repository.dart';
import 'package_storage.dart';
import 'version_ordering.dart';

class PackageArchive {
  final Stream<List<int>> data;

  const PackageArchive(this.data);
}

abstract class PackageService {
  Future<PackageMetadataDTO> getPackageMetadata(String name);
  Future<PackageArchive> getPackageArchive(String name, String version);
  Future<List<PackageSummaryDTO>> getPackagesUploadedBy(int userId);
  Future<PackageListDTO> listRecentPackages({required int limit, required int offset});
  /// Retorna o novo estado (`liked`) e a contagem atualizada num round-trip só.
  Future<(bool liked, int count)> toggleLike(String name, int userId);
  Future<bool> isLikedByUser(String name, int userId);
  Future<List<PackageSummaryDTO>> getLikedPackagesFor(int userId);
}

@Service()
class PackageServiceImpl implements PackageService {
  final PackageRepository _repository;
  final PackageStorage _storage;
  final ApplicationSettings _settings;
  final PackageLikeRepository _likes;
  final PackageDownloadRepository _downloads;

  PackageServiceImpl(
    this._repository,
    this._storage,
    this._settings,
    this._likes,
    this._downloads,
  );

  @override
  Future<PackageMetadataDTO> getPackageMetadata(String name) async {
    final package = await _repository.findByName(name);
    final rows = package == null
        ? const <(PackageVersion, String?)>[]
        : await _repository.findVersionsWithUploader(name);

    if (package == null || rows.isEmpty) {
      throw ResponseException.notFound({
        'error': {
          'code': 'not_found',
          'message': 'Package $name not found',
        },
      });
    }

    final byVersion = {for (final row in rows) row.$1.version: row};
    final sortedVersions = sortVersions(byVersion.keys.toList());
    final sorted = sortedVersions.map((v) => byVersion[v]!).toList();
    final latest = byVersion[pickLatestVersion(sortedVersions)]!;

    final likeCount = await _likes.countFor(name);
    final downloadsTotal = await _downloads.totalFor(name);
    final dailyRows = await _downloads.dailyFor(name);

    return PackageMetadataDTO(
      name: name,
      latest: _toVersionDTO(latest.$1, latest.$2),
      versions: sorted.map((row) => _toVersionDTO(row.$1, row.$2)).toList(),
      likeCount: likeCount,
      downloadsTotal: downloadsTotal,
      downloadsDaily: _fillDailyGaps(dailyRows),
    );
  }

  @override
  Future<PackageArchive> getPackageArchive(String name, String version) async {
    final row = await _repository.findVersion(name, version);
    if (row == null) {
      throw ResponseException.notFound({
        'error': {
          'code': 'not_found',
          'message': 'Version $version of package $name not found',
        },
      });
    }

    final data = await _storage.read(row.archivePath);

    // Contagem de download nunca pode derrubar o download em si.
    unawaited(_downloads.recordDownload(name).catchError((_) {}));

    return PackageArchive(data);
  }

  @override
  Future<List<PackageSummaryDTO>> getPackagesUploadedBy(int userId) async {
    final packages = await _repository.findPackagesUploadedByUser(userId);
    return packages.map(_toSummaryDTO).toList();
  }

  @override
  Future<PackageListDTO> listRecentPackages({
    required int limit,
    required int offset,
  }) async {
    final packages = await _repository.listRecent(limit: limit, offset: offset);
    final total = await _repository.countAll();
    return PackageListDTO(
      packages: packages.map(_toSummaryDTO).toList(),
      total: total,
    );
  }

  @override
  Future<(bool liked, int count)> toggleLike(String name, int userId) async {
    final liked = await _likes.toggle(name, userId);
    final count = await _likes.countFor(name);
    return (liked, count);
  }

  @override
  Future<bool> isLikedByUser(String name, int userId) {
    return _likes.isLikedBy(name, userId);
  }

  @override
  Future<List<PackageSummaryDTO>> getLikedPackagesFor(int userId) async {
    final packages = await _likes.findLikedByUser(userId);
    return packages.map(_toSummaryDTO).toList();
  }

  /// Preenche com 0 os dias sem download no intervalo — o front espera uma
  /// série contínua pro sparkline, não só os dias com atividade.
  List<DownloadDayDTO> _fillDailyGaps(List<DownloadDay> rows, {int days = 30}) {
    final byDay = {for (final r in rows) r.day: r.count};
    final today = DateTime.now().toUtc();
    final start = DateTime.utc(today.year, today.month, today.day)
        .subtract(Duration(days: days - 1));

    return List.generate(days, (i) {
      final date = start.add(Duration(days: i)).toIso8601String().split('T').first;
      return DownloadDayDTO(date: date, count: byDay[date] ?? 0);
    });
  }

  PackageSummaryDTO _toSummaryDTO(Package p) => PackageSummaryDTO(
    name: p.name,
    latestVersion: p.latestVersion,
    createdAt: p.createdAt,
  );

  PackageVersionDTO _toVersionDTO(PackageVersion row, String? uploadedBy) {
    final baseUrl = _settings['env']['base_url'] as String;
    final pubspecMap = Map<String, dynamic>.from(
      loadYaml(row.pubspecYaml) as Map,
    );

    return PackageVersionDTO(
      version: row.version,
      archiveUrl:
          '$baseUrl/api/packages/${row.packageName}/versions/${row.version}.tar.gz',
      archiveSha256: row.archiveSha256,
      pubspec: pubspecMap,
      uploadedBy: uploadedBy,
    );
  }
}
