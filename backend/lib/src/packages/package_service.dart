import 'package:pub_semver/pub_semver.dart';
import 'package:vaden/vaden.dart';
import 'package:yaml/yaml.dart';

import '../../config/drift/app_database.dart';
import 'package_dto.dart';
import 'package_repository.dart';
import 'package_storage.dart';

class PackageArchive {
  final Stream<List<int>> data;

  const PackageArchive(this.data);
}

abstract class PackageService {
  Future<PackageMetadataDTO> getPackageMetadata(String name);
  Future<PackageArchive> getPackageArchive(String name, String version);
}

@Service()
class PackageServiceImpl implements PackageService {
  final PackageRepository _repository;
  final PackageStorage _storage;
  final ApplicationSettings _settings;

  PackageServiceImpl(this._repository, this._storage, this._settings);

  @override
  Future<PackageMetadataDTO> getPackageMetadata(String name) async {
    final package = await _repository.findByName(name);
    final rows = package == null
        ? const <PackageVersion>[]
        : await _repository.findVersions(name);

    if (package == null || rows.isEmpty) {
      throw ResponseException.notFound({
        'error': {
          'code': 'not_found',
          'message': 'Package $name not found',
        },
      });
    }

    final sorted = [...rows]..sort(
      (a, b) => Version.parse(a.version).compareTo(Version.parse(b.version)),
    );

    final stableRows = sorted.where(
      (row) => !Version.parse(row.version).isPreRelease,
    );
    // Se só existirem pre-releases, usa a mais recente delas como "latest".
    final latestRow = stableRows.isNotEmpty ? stableRows.last : sorted.last;

    return PackageMetadataDTO(
      name: name,
      latest: _toVersionDTO(latestRow),
      versions: sorted.map(_toVersionDTO).toList(),
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
    return PackageArchive(data);
  }

  PackageVersionDTO _toVersionDTO(PackageVersion row) {
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
    );
  }
}
