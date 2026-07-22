import 'package:backend/config/drift/app_database.dart';
import 'package:backend/src/packages/package_repository.dart';
import 'package:backend/src/packages/package_service.dart';
import 'package:backend/src/packages/package_storage.dart';
import 'package:test/test.dart';
import 'package:vaden/vaden.dart';

class FakePackageRepository implements PackageRepository {
  Package? package;
  List<PackageVersion> versions = [];

  @override
  Future<Package?> findByName(String name) async => package;

  @override
  Future<List<PackageVersion>> findVersions(String packageName) async =>
      versions;

  @override
  Future<PackageVersion?> findVersion(String packageName, String version) async {
    for (final row in versions) {
      if (row.packageName == packageName && row.version == version) {
        return row;
      }
    }
    return null;
  }

  @override
  Future<void> saveNewVersion({
    required String packageName,
    required String version,
    required String pubspecYaml,
    required String archiveSha256,
    required String archivePath,
    required String latestVersion,
    int? uploaderTokenId,
  }) async {
    package = Package(
      name: packageName,
      createdAt: package?.createdAt ?? DateTime.now(),
      latestVersion: latestVersion,
    );
    versions = [
      ...versions,
      PackageVersion(
        id: versions.length + 1,
        packageName: packageName,
        version: version,
        pubspecYaml: pubspecYaml,
        archiveSha256: archiveSha256,
        archivePath: archivePath,
        uploadedAt: DateTime.now(),
        uploaderTokenId: uploaderTokenId,
      ),
    ];
  }
}

class FakePackageStorage implements PackageStorage {
  final Map<String, List<int>> files = {};

  @override
  Future<Stream<List<int>>> read(String path) async {
    final bytes = files[path];
    if (bytes == null) {
      throw Exception('File not found: $path');
    }
    return Stream.value(bytes);
  }

  @override
  Future<void> write(String path, Stream<List<int>> data) async {
    files[path] = await data.expand((chunk) => chunk).toList();
  }
}

PackageVersion _version(String version) {
  return PackageVersion(
    id: version.hashCode,
    packageName: 'meu_pacote',
    version: version,
    pubspecYaml: 'name: meu_pacote\nversion: $version\n',
    archiveSha256: 'sha-$version',
    archivePath: 'meu_pacote/$version.tar.gz',
    uploadedAt: DateTime.utc(2026, 1, 1),
  );
}

void main() {
  late FakePackageRepository repository;
  late FakePackageStorage storage;
  late ApplicationSettings settings;
  late PackageServiceImpl service;

  setUp(() {
    repository = FakePackageRepository();
    storage = FakePackageStorage();
    settings = ApplicationSettings.load('application.yaml');
    service = PackageServiceImpl(repository, storage, settings);
  });

  test('throws 404 when package does not exist', () async {
    repository.package = null;

    await expectLater(
      () => service.getPackageMetadata('inexistente'),
      throwsA(
        isA<ResponseException>().having((e) => e.code, 'code', 404),
      ),
    );
  });

  test('throws 404 when package exists but has no versions', () async {
    repository.package = Package(
      name: 'meu_pacote',
      createdAt: DateTime.utc(2026, 1, 1),
      latestVersion: '0.0.0',
    );
    repository.versions = [];

    await expectLater(
      () => service.getPackageMetadata('meu_pacote'),
      throwsA(isA<ResponseException>()),
    );
  });

  test('orders versions by semver, not lexicographically', () async {
    repository.package = Package(
      name: 'meu_pacote',
      createdAt: DateTime.utc(2026, 1, 1),
      latestVersion: '1.10.0',
    );
    repository.versions = [
      _version('1.10.0'),
      _version('1.2.0'),
      _version('1.9.0'),
    ];

    final metadata = await service.getPackageMetadata('meu_pacote');

    expect(
      metadata.versions.map((v) => v.version).toList(),
      ['1.2.0', '1.9.0', '1.10.0'],
    );
    expect(metadata.latest.version, '1.10.0');
  });

  test('latest skips pre-releases when a stable version exists', () async {
    repository.package = Package(
      name: 'meu_pacote',
      createdAt: DateTime.utc(2026, 1, 1),
      latestVersion: '1.5.0',
    );
    repository.versions = [
      _version('1.5.0'),
      _version('2.0.0-beta'),
    ];

    final metadata = await service.getPackageMetadata('meu_pacote');

    expect(metadata.latest.version, '1.5.0');
  });

  test('latest falls back to a pre-release when no stable exists', () async {
    repository.package = Package(
      name: 'meu_pacote',
      createdAt: DateTime.utc(2026, 1, 1),
      latestVersion: '1.0.0-beta',
    );
    repository.versions = [
      _version('1.0.0-alpha'),
      _version('1.0.0-beta'),
    ];

    final metadata = await service.getPackageMetadata('meu_pacote');

    expect(metadata.latest.version, '1.0.0-beta');
  });

  test('builds archive_url from base_url and parses pubspec as a map', () async {
    repository.package = Package(
      name: 'meu_pacote',
      createdAt: DateTime.utc(2026, 1, 1),
      latestVersion: '1.0.0',
    );
    repository.versions = [_version('1.0.0')];

    final metadata = await service.getPackageMetadata('meu_pacote');
    final latest = metadata.latest;

    expect(
      latest.archiveUrl,
      'http://localhost/api/packages/meu_pacote/versions/1.0.0.tar.gz',
    );
    expect(latest.pubspec['name'], 'meu_pacote');
    expect(latest.pubspec['version'], '1.0.0');
  });

  test('getPackageArchive throws 404 when the version does not exist', () async {
    repository.versions = [];

    await expectLater(
      () => service.getPackageArchive('meu_pacote', '9.9.9'),
      throwsA(
        isA<ResponseException>().having((e) => e.code, 'code', 404),
      ),
    );
  });

  test('getPackageArchive streams bytes from storage using archivePath', () async {
    final row = _version('1.0.0');
    repository.versions = [row];
    storage.files[row.archivePath] = [1, 2, 3, 4];

    final archive = await service.getPackageArchive('meu_pacote', '1.0.0');
    final bytes = await archive.data.expand((chunk) => chunk).toList();

    expect(bytes, [1, 2, 3, 4]);
  });
}
