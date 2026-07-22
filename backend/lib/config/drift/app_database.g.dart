// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PackagesTable extends Packages with TableInfo<$PackagesTable, Package> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _latestVersionMeta = const VerificationMeta(
    'latestVersion',
  );
  @override
  late final GeneratedColumn<String> latestVersion = GeneratedColumn<String>(
    'latest_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [name, createdAt, latestVersion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'packages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Package> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('latest_version')) {
      context.handle(
        _latestVersionMeta,
        latestVersion.isAcceptableOrUnknown(
          data['latest_version']!,
          _latestVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_latestVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  Package map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Package(
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      latestVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}latest_version'],
      )!,
    );
  }

  @override
  $PackagesTable createAlias(String alias) {
    return $PackagesTable(attachedDatabase, alias);
  }
}

class Package extends DataClass implements Insertable<Package> {
  final String name;
  final DateTime createdAt;
  final String latestVersion;
  const Package({
    required this.name,
    required this.createdAt,
    required this.latestVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['latest_version'] = Variable<String>(latestVersion);
    return map;
  }

  PackagesCompanion toCompanion(bool nullToAbsent) {
    return PackagesCompanion(
      name: Value(name),
      createdAt: Value(createdAt),
      latestVersion: Value(latestVersion),
    );
  }

  factory Package.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Package(
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      latestVersion: serializer.fromJson<String>(json['latestVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'latestVersion': serializer.toJson<String>(latestVersion),
    };
  }

  Package copyWith({
    String? name,
    DateTime? createdAt,
    String? latestVersion,
  }) => Package(
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    latestVersion: latestVersion ?? this.latestVersion,
  );
  Package copyWithCompanion(PackagesCompanion data) {
    return Package(
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      latestVersion: data.latestVersion.present
          ? data.latestVersion.value
          : this.latestVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Package(')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('latestVersion: $latestVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, createdAt, latestVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Package &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.latestVersion == this.latestVersion);
}

class PackagesCompanion extends UpdateCompanion<Package> {
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<String> latestVersion;
  final Value<int> rowid;
  const PackagesCompanion({
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.latestVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PackagesCompanion.insert({
    required String name,
    this.createdAt = const Value.absent(),
    required String latestVersion,
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       latestVersion = Value(latestVersion);
  static Insertable<Package> custom({
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<String>? latestVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (latestVersion != null) 'latest_version': latestVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PackagesCompanion copyWith({
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<String>? latestVersion,
    Value<int>? rowid,
  }) {
    return PackagesCompanion(
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      latestVersion: latestVersion ?? this.latestVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (latestVersion.present) {
      map['latest_version'] = Variable<String>(latestVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackagesCompanion(')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('latestVersion: $latestVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PackageVersionsTable extends PackageVersions
    with TableInfo<$PackageVersionsTable, PackageVersion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackageVersionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES packages (name)',
    ),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pubspecYamlMeta = const VerificationMeta(
    'pubspecYaml',
  );
  @override
  late final GeneratedColumn<String> pubspecYaml = GeneratedColumn<String>(
    'pubspec_yaml',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archiveSha256Meta = const VerificationMeta(
    'archiveSha256',
  );
  @override
  late final GeneratedColumn<String> archiveSha256 = GeneratedColumn<String>(
    'archive_sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivePathMeta = const VerificationMeta(
    'archivePath',
  );
  @override
  late final GeneratedColumn<String> archivePath = GeneratedColumn<String>(
    'archive_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<DateTime> uploadedAt = GeneratedColumn<DateTime>(
    'uploaded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _uploaderTokenIdMeta = const VerificationMeta(
    'uploaderTokenId',
  );
  @override
  late final GeneratedColumn<String> uploaderTokenId = GeneratedColumn<String>(
    'uploader_token_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packageName,
    version,
    pubspecYaml,
    archiveSha256,
    archivePath,
    uploadedAt,
    uploaderTokenId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'package_versions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PackageVersion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('pubspec_yaml')) {
      context.handle(
        _pubspecYamlMeta,
        pubspecYaml.isAcceptableOrUnknown(
          data['pubspec_yaml']!,
          _pubspecYamlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pubspecYamlMeta);
    }
    if (data.containsKey('archive_sha256')) {
      context.handle(
        _archiveSha256Meta,
        archiveSha256.isAcceptableOrUnknown(
          data['archive_sha256']!,
          _archiveSha256Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_archiveSha256Meta);
    }
    if (data.containsKey('archive_path')) {
      context.handle(
        _archivePathMeta,
        archivePath.isAcceptableOrUnknown(
          data['archive_path']!,
          _archivePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_archivePathMeta);
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    }
    if (data.containsKey('uploader_token_id')) {
      context.handle(
        _uploaderTokenIdMeta,
        uploaderTokenId.isAcceptableOrUnknown(
          data['uploader_token_id']!,
          _uploaderTokenIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {packageName, version},
  ];
  @override
  PackageVersion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PackageVersion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      pubspecYaml: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pubspec_yaml'],
      )!,
      archiveSha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}archive_sha256'],
      )!,
      archivePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}archive_path'],
      )!,
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}uploaded_at'],
      )!,
      uploaderTokenId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uploader_token_id'],
      ),
    );
  }

  @override
  $PackageVersionsTable createAlias(String alias) {
    return $PackageVersionsTable(attachedDatabase, alias);
  }
}

class PackageVersion extends DataClass implements Insertable<PackageVersion> {
  final int id;
  final String packageName;
  final String version;
  final String pubspecYaml;
  final String archiveSha256;
  final String archivePath;
  final DateTime uploadedAt;
  final String? uploaderTokenId;
  const PackageVersion({
    required this.id,
    required this.packageName,
    required this.version,
    required this.pubspecYaml,
    required this.archiveSha256,
    required this.archivePath,
    required this.uploadedAt,
    this.uploaderTokenId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['package_name'] = Variable<String>(packageName);
    map['version'] = Variable<String>(version);
    map['pubspec_yaml'] = Variable<String>(pubspecYaml);
    map['archive_sha256'] = Variable<String>(archiveSha256);
    map['archive_path'] = Variable<String>(archivePath);
    map['uploaded_at'] = Variable<DateTime>(uploadedAt);
    if (!nullToAbsent || uploaderTokenId != null) {
      map['uploader_token_id'] = Variable<String>(uploaderTokenId);
    }
    return map;
  }

  PackageVersionsCompanion toCompanion(bool nullToAbsent) {
    return PackageVersionsCompanion(
      id: Value(id),
      packageName: Value(packageName),
      version: Value(version),
      pubspecYaml: Value(pubspecYaml),
      archiveSha256: Value(archiveSha256),
      archivePath: Value(archivePath),
      uploadedAt: Value(uploadedAt),
      uploaderTokenId: uploaderTokenId == null && nullToAbsent
          ? const Value.absent()
          : Value(uploaderTokenId),
    );
  }

  factory PackageVersion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PackageVersion(
      id: serializer.fromJson<int>(json['id']),
      packageName: serializer.fromJson<String>(json['packageName']),
      version: serializer.fromJson<String>(json['version']),
      pubspecYaml: serializer.fromJson<String>(json['pubspecYaml']),
      archiveSha256: serializer.fromJson<String>(json['archiveSha256']),
      archivePath: serializer.fromJson<String>(json['archivePath']),
      uploadedAt: serializer.fromJson<DateTime>(json['uploadedAt']),
      uploaderTokenId: serializer.fromJson<String?>(json['uploaderTokenId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packageName': serializer.toJson<String>(packageName),
      'version': serializer.toJson<String>(version),
      'pubspecYaml': serializer.toJson<String>(pubspecYaml),
      'archiveSha256': serializer.toJson<String>(archiveSha256),
      'archivePath': serializer.toJson<String>(archivePath),
      'uploadedAt': serializer.toJson<DateTime>(uploadedAt),
      'uploaderTokenId': serializer.toJson<String?>(uploaderTokenId),
    };
  }

  PackageVersion copyWith({
    int? id,
    String? packageName,
    String? version,
    String? pubspecYaml,
    String? archiveSha256,
    String? archivePath,
    DateTime? uploadedAt,
    Value<String?> uploaderTokenId = const Value.absent(),
  }) => PackageVersion(
    id: id ?? this.id,
    packageName: packageName ?? this.packageName,
    version: version ?? this.version,
    pubspecYaml: pubspecYaml ?? this.pubspecYaml,
    archiveSha256: archiveSha256 ?? this.archiveSha256,
    archivePath: archivePath ?? this.archivePath,
    uploadedAt: uploadedAt ?? this.uploadedAt,
    uploaderTokenId: uploaderTokenId.present
        ? uploaderTokenId.value
        : this.uploaderTokenId,
  );
  PackageVersion copyWithCompanion(PackageVersionsCompanion data) {
    return PackageVersion(
      id: data.id.present ? data.id.value : this.id,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      version: data.version.present ? data.version.value : this.version,
      pubspecYaml: data.pubspecYaml.present
          ? data.pubspecYaml.value
          : this.pubspecYaml,
      archiveSha256: data.archiveSha256.present
          ? data.archiveSha256.value
          : this.archiveSha256,
      archivePath: data.archivePath.present
          ? data.archivePath.value
          : this.archivePath,
      uploadedAt: data.uploadedAt.present
          ? data.uploadedAt.value
          : this.uploadedAt,
      uploaderTokenId: data.uploaderTokenId.present
          ? data.uploaderTokenId.value
          : this.uploaderTokenId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PackageVersion(')
          ..write('id: $id, ')
          ..write('packageName: $packageName, ')
          ..write('version: $version, ')
          ..write('pubspecYaml: $pubspecYaml, ')
          ..write('archiveSha256: $archiveSha256, ')
          ..write('archivePath: $archivePath, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('uploaderTokenId: $uploaderTokenId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packageName,
    version,
    pubspecYaml,
    archiveSha256,
    archivePath,
    uploadedAt,
    uploaderTokenId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PackageVersion &&
          other.id == this.id &&
          other.packageName == this.packageName &&
          other.version == this.version &&
          other.pubspecYaml == this.pubspecYaml &&
          other.archiveSha256 == this.archiveSha256 &&
          other.archivePath == this.archivePath &&
          other.uploadedAt == this.uploadedAt &&
          other.uploaderTokenId == this.uploaderTokenId);
}

class PackageVersionsCompanion extends UpdateCompanion<PackageVersion> {
  final Value<int> id;
  final Value<String> packageName;
  final Value<String> version;
  final Value<String> pubspecYaml;
  final Value<String> archiveSha256;
  final Value<String> archivePath;
  final Value<DateTime> uploadedAt;
  final Value<String?> uploaderTokenId;
  const PackageVersionsCompanion({
    this.id = const Value.absent(),
    this.packageName = const Value.absent(),
    this.version = const Value.absent(),
    this.pubspecYaml = const Value.absent(),
    this.archiveSha256 = const Value.absent(),
    this.archivePath = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.uploaderTokenId = const Value.absent(),
  });
  PackageVersionsCompanion.insert({
    this.id = const Value.absent(),
    required String packageName,
    required String version,
    required String pubspecYaml,
    required String archiveSha256,
    required String archivePath,
    this.uploadedAt = const Value.absent(),
    this.uploaderTokenId = const Value.absent(),
  }) : packageName = Value(packageName),
       version = Value(version),
       pubspecYaml = Value(pubspecYaml),
       archiveSha256 = Value(archiveSha256),
       archivePath = Value(archivePath);
  static Insertable<PackageVersion> custom({
    Expression<int>? id,
    Expression<String>? packageName,
    Expression<String>? version,
    Expression<String>? pubspecYaml,
    Expression<String>? archiveSha256,
    Expression<String>? archivePath,
    Expression<DateTime>? uploadedAt,
    Expression<String>? uploaderTokenId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packageName != null) 'package_name': packageName,
      if (version != null) 'version': version,
      if (pubspecYaml != null) 'pubspec_yaml': pubspecYaml,
      if (archiveSha256 != null) 'archive_sha256': archiveSha256,
      if (archivePath != null) 'archive_path': archivePath,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (uploaderTokenId != null) 'uploader_token_id': uploaderTokenId,
    });
  }

  PackageVersionsCompanion copyWith({
    Value<int>? id,
    Value<String>? packageName,
    Value<String>? version,
    Value<String>? pubspecYaml,
    Value<String>? archiveSha256,
    Value<String>? archivePath,
    Value<DateTime>? uploadedAt,
    Value<String?>? uploaderTokenId,
  }) {
    return PackageVersionsCompanion(
      id: id ?? this.id,
      packageName: packageName ?? this.packageName,
      version: version ?? this.version,
      pubspecYaml: pubspecYaml ?? this.pubspecYaml,
      archiveSha256: archiveSha256 ?? this.archiveSha256,
      archivePath: archivePath ?? this.archivePath,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      uploaderTokenId: uploaderTokenId ?? this.uploaderTokenId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (pubspecYaml.present) {
      map['pubspec_yaml'] = Variable<String>(pubspecYaml.value);
    }
    if (archiveSha256.present) {
      map['archive_sha256'] = Variable<String>(archiveSha256.value);
    }
    if (archivePath.present) {
      map['archive_path'] = Variable<String>(archivePath.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<DateTime>(uploadedAt.value);
    }
    if (uploaderTokenId.present) {
      map['uploader_token_id'] = Variable<String>(uploaderTokenId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackageVersionsCompanion(')
          ..write('id: $id, ')
          ..write('packageName: $packageName, ')
          ..write('version: $version, ')
          ..write('pubspecYaml: $pubspecYaml, ')
          ..write('archiveSha256: $archiveSha256, ')
          ..write('archivePath: $archivePath, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('uploaderTokenId: $uploaderTokenId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PackagesTable packages = $PackagesTable(this);
  late final $PackageVersionsTable packageVersions = $PackageVersionsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    packages,
    packageVersions,
  ];
}

typedef $$PackagesTableCreateCompanionBuilder =
    PackagesCompanion Function({
      required String name,
      Value<DateTime> createdAt,
      required String latestVersion,
      Value<int> rowid,
    });
typedef $$PackagesTableUpdateCompanionBuilder =
    PackagesCompanion Function({
      Value<String> name,
      Value<DateTime> createdAt,
      Value<String> latestVersion,
      Value<int> rowid,
    });

final class $$PackagesTableReferences
    extends BaseReferences<_$AppDatabase, $PackagesTable, Package> {
  $$PackagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PackageVersionsTable, List<PackageVersion>>
  _packageVersionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.packageVersions,
    aliasName: $_aliasNameGenerator(
      db.packages.name,
      db.packageVersions.packageName,
    ),
  );

  $$PackageVersionsTableProcessedTableManager get packageVersionsRefs {
    final manager =
        $$PackageVersionsTableTableManager($_db, $_db.packageVersions).filter(
          (f) => f.packageName.name.sqlEquals($_itemColumn<String>('name')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _packageVersionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PackagesTableFilterComposer
    extends Composer<_$AppDatabase, $PackagesTable> {
  $$PackagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get latestVersion => $composableBuilder(
    column: $table.latestVersion,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> packageVersionsRefs(
    Expression<bool> Function($$PackageVersionsTableFilterComposer f) f,
  ) {
    final $$PackageVersionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.name,
      referencedTable: $db.packageVersions,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackageVersionsTableFilterComposer(
            $db: $db,
            $table: $db.packageVersions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PackagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PackagesTable> {
  $$PackagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get latestVersion => $composableBuilder(
    column: $table.latestVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PackagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PackagesTable> {
  $$PackagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get latestVersion => $composableBuilder(
    column: $table.latestVersion,
    builder: (column) => column,
  );

  Expression<T> packageVersionsRefs<T extends Object>(
    Expression<T> Function($$PackageVersionsTableAnnotationComposer a) f,
  ) {
    final $$PackageVersionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.name,
      referencedTable: $db.packageVersions,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackageVersionsTableAnnotationComposer(
            $db: $db,
            $table: $db.packageVersions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PackagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PackagesTable,
          Package,
          $$PackagesTableFilterComposer,
          $$PackagesTableOrderingComposer,
          $$PackagesTableAnnotationComposer,
          $$PackagesTableCreateCompanionBuilder,
          $$PackagesTableUpdateCompanionBuilder,
          (Package, $$PackagesTableReferences),
          Package,
          PrefetchHooks Function({bool packageVersionsRefs})
        > {
  $$PackagesTableTableManager(_$AppDatabase db, $PackagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PackagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> latestVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PackagesCompanion(
                name: name,
                createdAt: createdAt,
                latestVersion: latestVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
                required String latestVersion,
                Value<int> rowid = const Value.absent(),
              }) => PackagesCompanion.insert(
                name: name,
                createdAt: createdAt,
                latestVersion: latestVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PackagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packageVersionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (packageVersionsRefs) db.packageVersions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (packageVersionsRefs)
                    await $_getPrefetchedData<
                      Package,
                      $PackagesTable,
                      PackageVersion
                    >(
                      currentTable: table,
                      referencedTable: $$PackagesTableReferences
                          ._packageVersionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$PackagesTableReferences(
                        db,
                        table,
                        p0,
                      ).packageVersionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.packageName == item.name,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PackagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PackagesTable,
      Package,
      $$PackagesTableFilterComposer,
      $$PackagesTableOrderingComposer,
      $$PackagesTableAnnotationComposer,
      $$PackagesTableCreateCompanionBuilder,
      $$PackagesTableUpdateCompanionBuilder,
      (Package, $$PackagesTableReferences),
      Package,
      PrefetchHooks Function({bool packageVersionsRefs})
    >;
typedef $$PackageVersionsTableCreateCompanionBuilder =
    PackageVersionsCompanion Function({
      Value<int> id,
      required String packageName,
      required String version,
      required String pubspecYaml,
      required String archiveSha256,
      required String archivePath,
      Value<DateTime> uploadedAt,
      Value<String?> uploaderTokenId,
    });
typedef $$PackageVersionsTableUpdateCompanionBuilder =
    PackageVersionsCompanion Function({
      Value<int> id,
      Value<String> packageName,
      Value<String> version,
      Value<String> pubspecYaml,
      Value<String> archiveSha256,
      Value<String> archivePath,
      Value<DateTime> uploadedAt,
      Value<String?> uploaderTokenId,
    });

final class $$PackageVersionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PackageVersionsTable, PackageVersion> {
  $$PackageVersionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PackagesTable _packageNameTable(_$AppDatabase db) =>
      db.packages.createAlias(
        $_aliasNameGenerator(db.packageVersions.packageName, db.packages.name),
      );

  $$PackagesTableProcessedTableManager get packageName {
    final $_column = $_itemColumn<String>('package_name')!;

    final manager = $$PackagesTableTableManager(
      $_db,
      $_db.packages,
    ).filter((f) => f.name.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packageNameTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PackageVersionsTableFilterComposer
    extends Composer<_$AppDatabase, $PackageVersionsTable> {
  $$PackageVersionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pubspecYaml => $composableBuilder(
    column: $table.pubspecYaml,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get archiveSha256 => $composableBuilder(
    column: $table.archiveSha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get archivePath => $composableBuilder(
    column: $table.archivePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uploaderTokenId => $composableBuilder(
    column: $table.uploaderTokenId,
    builder: (column) => ColumnFilters(column),
  );

  $$PackagesTableFilterComposer get packageName {
    final $$PackagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.packages,
      getReferencedColumn: (t) => t.name,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagesTableFilterComposer(
            $db: $db,
            $table: $db.packages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackageVersionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PackageVersionsTable> {
  $$PackageVersionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pubspecYaml => $composableBuilder(
    column: $table.pubspecYaml,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get archiveSha256 => $composableBuilder(
    column: $table.archiveSha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get archivePath => $composableBuilder(
    column: $table.archivePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploaderTokenId => $composableBuilder(
    column: $table.uploaderTokenId,
    builder: (column) => ColumnOrderings(column),
  );

  $$PackagesTableOrderingComposer get packageName {
    final $$PackagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.packages,
      getReferencedColumn: (t) => t.name,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagesTableOrderingComposer(
            $db: $db,
            $table: $db.packages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackageVersionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PackageVersionsTable> {
  $$PackageVersionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get pubspecYaml => $composableBuilder(
    column: $table.pubspecYaml,
    builder: (column) => column,
  );

  GeneratedColumn<String> get archiveSha256 => $composableBuilder(
    column: $table.archiveSha256,
    builder: (column) => column,
  );

  GeneratedColumn<String> get archivePath => $composableBuilder(
    column: $table.archivePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uploaderTokenId => $composableBuilder(
    column: $table.uploaderTokenId,
    builder: (column) => column,
  );

  $$PackagesTableAnnotationComposer get packageName {
    final $$PackagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packageName,
      referencedTable: $db.packages,
      getReferencedColumn: (t) => t.name,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackagesTableAnnotationComposer(
            $db: $db,
            $table: $db.packages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackageVersionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PackageVersionsTable,
          PackageVersion,
          $$PackageVersionsTableFilterComposer,
          $$PackageVersionsTableOrderingComposer,
          $$PackageVersionsTableAnnotationComposer,
          $$PackageVersionsTableCreateCompanionBuilder,
          $$PackageVersionsTableUpdateCompanionBuilder,
          (PackageVersion, $$PackageVersionsTableReferences),
          PackageVersion,
          PrefetchHooks Function({bool packageName})
        > {
  $$PackageVersionsTableTableManager(
    _$AppDatabase db,
    $PackageVersionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackageVersionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackageVersionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PackageVersionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> packageName = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String> pubspecYaml = const Value.absent(),
                Value<String> archiveSha256 = const Value.absent(),
                Value<String> archivePath = const Value.absent(),
                Value<DateTime> uploadedAt = const Value.absent(),
                Value<String?> uploaderTokenId = const Value.absent(),
              }) => PackageVersionsCompanion(
                id: id,
                packageName: packageName,
                version: version,
                pubspecYaml: pubspecYaml,
                archiveSha256: archiveSha256,
                archivePath: archivePath,
                uploadedAt: uploadedAt,
                uploaderTokenId: uploaderTokenId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String packageName,
                required String version,
                required String pubspecYaml,
                required String archiveSha256,
                required String archivePath,
                Value<DateTime> uploadedAt = const Value.absent(),
                Value<String?> uploaderTokenId = const Value.absent(),
              }) => PackageVersionsCompanion.insert(
                id: id,
                packageName: packageName,
                version: version,
                pubspecYaml: pubspecYaml,
                archiveSha256: archiveSha256,
                archivePath: archivePath,
                uploadedAt: uploadedAt,
                uploaderTokenId: uploaderTokenId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PackageVersionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packageName = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (packageName) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.packageName,
                                referencedTable:
                                    $$PackageVersionsTableReferences
                                        ._packageNameTable(db),
                                referencedColumn:
                                    $$PackageVersionsTableReferences
                                        ._packageNameTable(db)
                                        .name,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PackageVersionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PackageVersionsTable,
      PackageVersion,
      $$PackageVersionsTableFilterComposer,
      $$PackageVersionsTableOrderingComposer,
      $$PackageVersionsTableAnnotationComposer,
      $$PackageVersionsTableCreateCompanionBuilder,
      $$PackageVersionsTableUpdateCompanionBuilder,
      (PackageVersion, $$PackageVersionsTableReferences),
      PackageVersion,
      PrefetchHooks Function({bool packageName})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PackagesTableTableManager get packages =>
      $$PackagesTableTableManager(_db, _db.packages);
  $$PackageVersionsTableTableManager get packageVersions =>
      $$PackageVersionsTableTableManager(_db, _db.packageVersions);
}
