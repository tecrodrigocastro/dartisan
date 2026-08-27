// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
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
  static const VerificationMeta _githubIdMeta = const VerificationMeta(
    'githubId',
  );
  @override
  late final GeneratedColumn<int> githubId = GeneratedColumn<int>(
    'github_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    passwordHash,
    role,
    createdAt,
    githubId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('github_id')) {
      context.handle(
        _githubIdMeta,
        githubId.isAcceptableOrUnknown(data['github_id']!, _githubIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      githubId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}github_id'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String? passwordHash;
  final String role;
  final DateTime createdAt;
  final int? githubId;
  const User({
    required this.id,
    required this.username,
    this.passwordHash,
    required this.role,
    required this.createdAt,
    this.githubId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || passwordHash != null) {
      map['password_hash'] = Variable<String>(passwordHash);
    }
    map['role'] = Variable<String>(role);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || githubId != null) {
      map['github_id'] = Variable<int>(githubId);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      passwordHash: passwordHash == null && nullToAbsent
          ? const Value.absent()
          : Value(passwordHash),
      role: Value(role),
      createdAt: Value(createdAt),
      githubId: githubId == null && nullToAbsent
          ? const Value.absent()
          : Value(githubId),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String?>(json['passwordHash']),
      role: serializer.fromJson<String>(json['role']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      githubId: serializer.fromJson<int?>(json['githubId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String?>(passwordHash),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'githubId': serializer.toJson<int?>(githubId),
    };
  }

  User copyWith({
    int? id,
    String? username,
    Value<String?> passwordHash = const Value.absent(),
    String? role,
    DateTime? createdAt,
    Value<int?> githubId = const Value.absent(),
  }) => User(
    id: id ?? this.id,
    username: username ?? this.username,
    passwordHash: passwordHash.present ? passwordHash.value : this.passwordHash,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
    githubId: githubId.present ? githubId.value : this.githubId,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      githubId: data.githubId.present ? data.githubId.value : this.githubId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('githubId: $githubId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, username, passwordHash, role, createdAt, githubId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.role == this.role &&
          other.createdAt == this.createdAt &&
          other.githubId == this.githubId);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String?> passwordHash;
  final Value<String> role;
  final Value<DateTime> createdAt;
  final Value<int?> githubId;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.githubId = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    this.passwordHash = const Value.absent(),
    required String role,
    this.createdAt = const Value.absent(),
    this.githubId = const Value.absent(),
  }) : username = Value(username),
       role = Value(role);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
    Expression<int>? githubId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
      if (githubId != null) 'github_id': githubId,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String?>? passwordHash,
    Value<String>? role,
    Value<DateTime>? createdAt,
    Value<int?>? githubId,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      githubId: githubId ?? this.githubId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (githubId.present) {
      map['github_id'] = Variable<int>(githubId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('githubId: $githubId')
          ..write(')'))
        .toString();
  }
}

class $RefreshTokensTable extends RefreshTokens
    with TableInfo<$RefreshTokensTable, RefreshToken> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RefreshTokensTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _tokenHashMeta = const VerificationMeta(
    'tokenHash',
  );
  @override
  late final GeneratedColumn<String> tokenHash = GeneratedColumn<String>(
    'token_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revokedAtMeta = const VerificationMeta(
    'revokedAt',
  );
  @override
  late final GeneratedColumn<DateTime> revokedAt = GeneratedColumn<DateTime>(
    'revoked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    tokenHash,
    createdAt,
    expiresAt,
    revokedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'refresh_tokens';
  @override
  VerificationContext validateIntegrity(
    Insertable<RefreshToken> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('token_hash')) {
      context.handle(
        _tokenHashMeta,
        tokenHash.isAcceptableOrUnknown(data['token_hash']!, _tokenHashMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('revoked_at')) {
      context.handle(
        _revokedAtMeta,
        revokedAt.isAcceptableOrUnknown(data['revoked_at']!, _revokedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RefreshToken map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RefreshToken(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      tokenHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_hash'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
      revokedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}revoked_at'],
      ),
    );
  }

  @override
  $RefreshTokensTable createAlias(String alias) {
    return $RefreshTokensTable(attachedDatabase, alias);
  }
}

class RefreshToken extends DataClass implements Insertable<RefreshToken> {
  final int id;
  final int userId;
  final String tokenHash;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? revokedAt;
  const RefreshToken({
    required this.id,
    required this.userId,
    required this.tokenHash,
    required this.createdAt,
    required this.expiresAt,
    this.revokedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['token_hash'] = Variable<String>(tokenHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    if (!nullToAbsent || revokedAt != null) {
      map['revoked_at'] = Variable<DateTime>(revokedAt);
    }
    return map;
  }

  RefreshTokensCompanion toCompanion(bool nullToAbsent) {
    return RefreshTokensCompanion(
      id: Value(id),
      userId: Value(userId),
      tokenHash: Value(tokenHash),
      createdAt: Value(createdAt),
      expiresAt: Value(expiresAt),
      revokedAt: revokedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(revokedAt),
    );
  }

  factory RefreshToken.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RefreshToken(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      tokenHash: serializer.fromJson<String>(json['tokenHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      revokedAt: serializer.fromJson<DateTime?>(json['revokedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'tokenHash': serializer.toJson<String>(tokenHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'revokedAt': serializer.toJson<DateTime?>(revokedAt),
    };
  }

  RefreshToken copyWith({
    int? id,
    int? userId,
    String? tokenHash,
    DateTime? createdAt,
    DateTime? expiresAt,
    Value<DateTime?> revokedAt = const Value.absent(),
  }) => RefreshToken(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    tokenHash: tokenHash ?? this.tokenHash,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt ?? this.expiresAt,
    revokedAt: revokedAt.present ? revokedAt.value : this.revokedAt,
  );
  RefreshToken copyWithCompanion(RefreshTokensCompanion data) {
    return RefreshToken(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      tokenHash: data.tokenHash.present ? data.tokenHash.value : this.tokenHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      revokedAt: data.revokedAt.present ? data.revokedAt.value : this.revokedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RefreshToken(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('tokenHash: $tokenHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('revokedAt: $revokedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, tokenHash, createdAt, expiresAt, revokedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RefreshToken &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.tokenHash == this.tokenHash &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt &&
          other.revokedAt == this.revokedAt);
}

class RefreshTokensCompanion extends UpdateCompanion<RefreshToken> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> tokenHash;
  final Value<DateTime> createdAt;
  final Value<DateTime> expiresAt;
  final Value<DateTime?> revokedAt;
  const RefreshTokensCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.tokenHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.revokedAt = const Value.absent(),
  });
  RefreshTokensCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String tokenHash,
    this.createdAt = const Value.absent(),
    required DateTime expiresAt,
    this.revokedAt = const Value.absent(),
  }) : userId = Value(userId),
       tokenHash = Value(tokenHash),
       expiresAt = Value(expiresAt);
  static Insertable<RefreshToken> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? tokenHash,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? revokedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (tokenHash != null) 'token_hash': tokenHash,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (revokedAt != null) 'revoked_at': revokedAt,
    });
  }

  RefreshTokensCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? tokenHash,
    Value<DateTime>? createdAt,
    Value<DateTime>? expiresAt,
    Value<DateTime?>? revokedAt,
  }) {
    return RefreshTokensCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tokenHash: tokenHash ?? this.tokenHash,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      revokedAt: revokedAt ?? this.revokedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (tokenHash.present) {
      map['token_hash'] = Variable<String>(tokenHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (revokedAt.present) {
      map['revoked_at'] = Variable<DateTime>(revokedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RefreshTokensCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('tokenHash: $tokenHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('revokedAt: $revokedAt')
          ..write(')'))
        .toString();
  }
}

class $PublishTokensTable extends PublishTokens
    with TableInfo<$PublishTokensTable, PublishToken> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PublishTokensTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _tokenHashMeta = const VerificationMeta(
    'tokenHash',
  );
  @override
  late final GeneratedColumn<String> tokenHash = GeneratedColumn<String>(
    'token_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revokedAtMeta = const VerificationMeta(
    'revokedAt',
  );
  @override
  late final GeneratedColumn<DateTime> revokedAt = GeneratedColumn<DateTime>(
    'revoked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    tokenHash,
    createdAt,
    lastUsedAt,
    revokedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'publish_tokens';
  @override
  VerificationContext validateIntegrity(
    Insertable<PublishToken> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('token_hash')) {
      context.handle(
        _tokenHashMeta,
        tokenHash.isAcceptableOrUnknown(data['token_hash']!, _tokenHashMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    if (data.containsKey('revoked_at')) {
      context.handle(
        _revokedAtMeta,
        revokedAt.isAcceptableOrUnknown(data['revoked_at']!, _revokedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PublishToken map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PublishToken(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      tokenHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_hash'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      ),
      revokedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}revoked_at'],
      ),
    );
  }

  @override
  $PublishTokensTable createAlias(String alias) {
    return $PublishTokensTable(attachedDatabase, alias);
  }
}

class PublishToken extends DataClass implements Insertable<PublishToken> {
  final int id;
  final int userId;
  final String tokenHash;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final DateTime? revokedAt;
  const PublishToken({
    required this.id,
    required this.userId,
    required this.tokenHash,
    required this.createdAt,
    this.lastUsedAt,
    this.revokedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['token_hash'] = Variable<String>(tokenHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    if (!nullToAbsent || revokedAt != null) {
      map['revoked_at'] = Variable<DateTime>(revokedAt);
    }
    return map;
  }

  PublishTokensCompanion toCompanion(bool nullToAbsent) {
    return PublishTokensCompanion(
      id: Value(id),
      userId: Value(userId),
      tokenHash: Value(tokenHash),
      createdAt: Value(createdAt),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      revokedAt: revokedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(revokedAt),
    );
  }

  factory PublishToken.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PublishToken(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      tokenHash: serializer.fromJson<String>(json['tokenHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      revokedAt: serializer.fromJson<DateTime?>(json['revokedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'tokenHash': serializer.toJson<String>(tokenHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'revokedAt': serializer.toJson<DateTime?>(revokedAt),
    };
  }

  PublishToken copyWith({
    int? id,
    int? userId,
    String? tokenHash,
    DateTime? createdAt,
    Value<DateTime?> lastUsedAt = const Value.absent(),
    Value<DateTime?> revokedAt = const Value.absent(),
  }) => PublishToken(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    tokenHash: tokenHash ?? this.tokenHash,
    createdAt: createdAt ?? this.createdAt,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
    revokedAt: revokedAt.present ? revokedAt.value : this.revokedAt,
  );
  PublishToken copyWithCompanion(PublishTokensCompanion data) {
    return PublishToken(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      tokenHash: data.tokenHash.present ? data.tokenHash.value : this.tokenHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
      revokedAt: data.revokedAt.present ? data.revokedAt.value : this.revokedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PublishToken(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('tokenHash: $tokenHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('revokedAt: $revokedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, tokenHash, createdAt, lastUsedAt, revokedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PublishToken &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.tokenHash == this.tokenHash &&
          other.createdAt == this.createdAt &&
          other.lastUsedAt == this.lastUsedAt &&
          other.revokedAt == this.revokedAt);
}

class PublishTokensCompanion extends UpdateCompanion<PublishToken> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> tokenHash;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastUsedAt;
  final Value<DateTime?> revokedAt;
  const PublishTokensCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.tokenHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.revokedAt = const Value.absent(),
  });
  PublishTokensCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String tokenHash,
    this.createdAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.revokedAt = const Value.absent(),
  }) : userId = Value(userId),
       tokenHash = Value(tokenHash);
  static Insertable<PublishToken> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? tokenHash,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastUsedAt,
    Expression<DateTime>? revokedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (tokenHash != null) 'token_hash': tokenHash,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (revokedAt != null) 'revoked_at': revokedAt,
    });
  }

  PublishTokensCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? tokenHash,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastUsedAt,
    Value<DateTime?>? revokedAt,
  }) {
    return PublishTokensCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tokenHash: tokenHash ?? this.tokenHash,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      revokedAt: revokedAt ?? this.revokedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (tokenHash.present) {
      map['token_hash'] = Variable<String>(tokenHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (revokedAt.present) {
      map['revoked_at'] = Variable<DateTime>(revokedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PublishTokensCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('tokenHash: $tokenHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('revokedAt: $revokedAt')
          ..write(')'))
        .toString();
  }
}

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
  late final GeneratedColumn<int> uploaderTokenId = GeneratedColumn<int>(
    'uploader_token_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES publish_tokens (id)',
    ),
  );
  static const VerificationMeta _uploaderUserIdMeta = const VerificationMeta(
    'uploaderUserId',
  );
  @override
  late final GeneratedColumn<int> uploaderUserId = GeneratedColumn<int>(
    'uploader_user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
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
    uploaderUserId,
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
    if (data.containsKey('uploader_user_id')) {
      context.handle(
        _uploaderUserIdMeta,
        uploaderUserId.isAcceptableOrUnknown(
          data['uploader_user_id']!,
          _uploaderUserIdMeta,
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
        DriftSqlType.int,
        data['${effectivePrefix}uploader_token_id'],
      ),
      uploaderUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uploader_user_id'],
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
  final int? uploaderTokenId;
  final int? uploaderUserId;
  const PackageVersion({
    required this.id,
    required this.packageName,
    required this.version,
    required this.pubspecYaml,
    required this.archiveSha256,
    required this.archivePath,
    required this.uploadedAt,
    this.uploaderTokenId,
    this.uploaderUserId,
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
      map['uploader_token_id'] = Variable<int>(uploaderTokenId);
    }
    if (!nullToAbsent || uploaderUserId != null) {
      map['uploader_user_id'] = Variable<int>(uploaderUserId);
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
      uploaderUserId: uploaderUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(uploaderUserId),
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
      uploaderTokenId: serializer.fromJson<int?>(json['uploaderTokenId']),
      uploaderUserId: serializer.fromJson<int?>(json['uploaderUserId']),
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
      'uploaderTokenId': serializer.toJson<int?>(uploaderTokenId),
      'uploaderUserId': serializer.toJson<int?>(uploaderUserId),
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
    Value<int?> uploaderTokenId = const Value.absent(),
    Value<int?> uploaderUserId = const Value.absent(),
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
    uploaderUserId: uploaderUserId.present
        ? uploaderUserId.value
        : this.uploaderUserId,
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
      uploaderUserId: data.uploaderUserId.present
          ? data.uploaderUserId.value
          : this.uploaderUserId,
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
          ..write('uploaderTokenId: $uploaderTokenId, ')
          ..write('uploaderUserId: $uploaderUserId')
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
    uploaderUserId,
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
          other.uploaderTokenId == this.uploaderTokenId &&
          other.uploaderUserId == this.uploaderUserId);
}

class PackageVersionsCompanion extends UpdateCompanion<PackageVersion> {
  final Value<int> id;
  final Value<String> packageName;
  final Value<String> version;
  final Value<String> pubspecYaml;
  final Value<String> archiveSha256;
  final Value<String> archivePath;
  final Value<DateTime> uploadedAt;
  final Value<int?> uploaderTokenId;
  final Value<int?> uploaderUserId;
  const PackageVersionsCompanion({
    this.id = const Value.absent(),
    this.packageName = const Value.absent(),
    this.version = const Value.absent(),
    this.pubspecYaml = const Value.absent(),
    this.archiveSha256 = const Value.absent(),
    this.archivePath = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.uploaderTokenId = const Value.absent(),
    this.uploaderUserId = const Value.absent(),
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
    this.uploaderUserId = const Value.absent(),
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
    Expression<int>? uploaderTokenId,
    Expression<int>? uploaderUserId,
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
      if (uploaderUserId != null) 'uploader_user_id': uploaderUserId,
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
    Value<int?>? uploaderTokenId,
    Value<int?>? uploaderUserId,
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
      uploaderUserId: uploaderUserId ?? this.uploaderUserId,
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
      map['uploader_token_id'] = Variable<int>(uploaderTokenId.value);
    }
    if (uploaderUserId.present) {
      map['uploader_user_id'] = Variable<int>(uploaderUserId.value);
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
          ..write('uploaderTokenId: $uploaderTokenId, ')
          ..write('uploaderUserId: $uploaderUserId')
          ..write(')'))
        .toString();
  }
}

class $PackageLikesTable extends PackageLikes
    with TableInfo<$PackageLikesTable, PackageLike> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackageLikesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
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
  @override
  List<GeneratedColumn> get $columns => [packageName, userId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'package_likes';
  @override
  VerificationContext validateIntegrity(
    Insertable<PackageLike> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packageName, userId};
  @override
  PackageLike map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PackageLike(
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PackageLikesTable createAlias(String alias) {
    return $PackageLikesTable(attachedDatabase, alias);
  }
}

class PackageLike extends DataClass implements Insertable<PackageLike> {
  final String packageName;
  final int userId;
  final DateTime createdAt;
  const PackageLike({
    required this.packageName,
    required this.userId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_name'] = Variable<String>(packageName);
    map['user_id'] = Variable<int>(userId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PackageLikesCompanion toCompanion(bool nullToAbsent) {
    return PackageLikesCompanion(
      packageName: Value(packageName),
      userId: Value(userId),
      createdAt: Value(createdAt),
    );
  }

  factory PackageLike.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PackageLike(
      packageName: serializer.fromJson<String>(json['packageName']),
      userId: serializer.fromJson<int>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packageName': serializer.toJson<String>(packageName),
      'userId': serializer.toJson<int>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PackageLike copyWith({
    String? packageName,
    int? userId,
    DateTime? createdAt,
  }) => PackageLike(
    packageName: packageName ?? this.packageName,
    userId: userId ?? this.userId,
    createdAt: createdAt ?? this.createdAt,
  );
  PackageLike copyWithCompanion(PackageLikesCompanion data) {
    return PackageLike(
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PackageLike(')
          ..write('packageName: $packageName, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packageName, userId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PackageLike &&
          other.packageName == this.packageName &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt);
}

class PackageLikesCompanion extends UpdateCompanion<PackageLike> {
  final Value<String> packageName;
  final Value<int> userId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PackageLikesCompanion({
    this.packageName = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PackageLikesCompanion.insert({
    required String packageName,
    required int userId,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : packageName = Value(packageName),
       userId = Value(userId);
  static Insertable<PackageLike> custom({
    Expression<String>? packageName,
    Expression<int>? userId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packageName != null) 'package_name': packageName,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PackageLikesCompanion copyWith({
    Value<String>? packageName,
    Value<int>? userId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PackageLikesCompanion(
      packageName: packageName ?? this.packageName,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackageLikesCompanion(')
          ..write('packageName: $packageName, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PackageDownloadDailyTable extends PackageDownloadDaily
    with TableInfo<$PackageDownloadDailyTable, PackageDownloadDailyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackageDownloadDailyTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [packageName, day, count];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'package_download_daily';
  @override
  VerificationContext validateIntegrity(
    Insertable<PackageDownloadDailyData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packageName, day};
  @override
  PackageDownloadDailyData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PackageDownloadDailyData(
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
    );
  }

  @override
  $PackageDownloadDailyTable createAlias(String alias) {
    return $PackageDownloadDailyTable(attachedDatabase, alias);
  }
}

class PackageDownloadDailyData extends DataClass
    implements Insertable<PackageDownloadDailyData> {
  final String packageName;
  final String day;
  final int count;
  const PackageDownloadDailyData({
    required this.packageName,
    required this.day,
    required this.count,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_name'] = Variable<String>(packageName);
    map['day'] = Variable<String>(day);
    map['count'] = Variable<int>(count);
    return map;
  }

  PackageDownloadDailyCompanion toCompanion(bool nullToAbsent) {
    return PackageDownloadDailyCompanion(
      packageName: Value(packageName),
      day: Value(day),
      count: Value(count),
    );
  }

  factory PackageDownloadDailyData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PackageDownloadDailyData(
      packageName: serializer.fromJson<String>(json['packageName']),
      day: serializer.fromJson<String>(json['day']),
      count: serializer.fromJson<int>(json['count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packageName': serializer.toJson<String>(packageName),
      'day': serializer.toJson<String>(day),
      'count': serializer.toJson<int>(count),
    };
  }

  PackageDownloadDailyData copyWith({
    String? packageName,
    String? day,
    int? count,
  }) => PackageDownloadDailyData(
    packageName: packageName ?? this.packageName,
    day: day ?? this.day,
    count: count ?? this.count,
  );
  PackageDownloadDailyData copyWithCompanion(
    PackageDownloadDailyCompanion data,
  ) {
    return PackageDownloadDailyData(
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      day: data.day.present ? data.day.value : this.day,
      count: data.count.present ? data.count.value : this.count,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PackageDownloadDailyData(')
          ..write('packageName: $packageName, ')
          ..write('day: $day, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packageName, day, count);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PackageDownloadDailyData &&
          other.packageName == this.packageName &&
          other.day == this.day &&
          other.count == this.count);
}

class PackageDownloadDailyCompanion
    extends UpdateCompanion<PackageDownloadDailyData> {
  final Value<String> packageName;
  final Value<String> day;
  final Value<int> count;
  final Value<int> rowid;
  const PackageDownloadDailyCompanion({
    this.packageName = const Value.absent(),
    this.day = const Value.absent(),
    this.count = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PackageDownloadDailyCompanion.insert({
    required String packageName,
    required String day,
    this.count = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : packageName = Value(packageName),
       day = Value(day);
  static Insertable<PackageDownloadDailyData> custom({
    Expression<String>? packageName,
    Expression<String>? day,
    Expression<int>? count,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packageName != null) 'package_name': packageName,
      if (day != null) 'day': day,
      if (count != null) 'count': count,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PackageDownloadDailyCompanion copyWith({
    Value<String>? packageName,
    Value<String>? day,
    Value<int>? count,
    Value<int>? rowid,
  }) {
    return PackageDownloadDailyCompanion(
      packageName: packageName ?? this.packageName,
      day: day ?? this.day,
      count: count ?? this.count,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackageDownloadDailyCompanion(')
          ..write('packageName: $packageName, ')
          ..write('day: $day, ')
          ..write('count: $count, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GithubConnectionsTable extends GithubConnections
    with TableInfo<$GithubConnectionsTable, GithubConnection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GithubConnectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _accessTokenEncryptedMeta =
      const VerificationMeta('accessTokenEncrypted');
  @override
  late final GeneratedColumn<String> accessTokenEncrypted =
      GeneratedColumn<String>(
        'access_token_encrypted',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _refreshTokenEncryptedMeta =
      const VerificationMeta('refreshTokenEncrypted');
  @override
  late final GeneratedColumn<String> refreshTokenEncrypted =
      GeneratedColumn<String>(
        'refresh_token_encrypted',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _accessTokenExpiresAtMeta =
      const VerificationMeta('accessTokenExpiresAt');
  @override
  late final GeneratedColumn<DateTime> accessTokenExpiresAt =
      GeneratedColumn<DateTime>(
        'access_token_expires_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    accessTokenEncrypted,
    refreshTokenEncrypted,
    accessTokenExpiresAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'github_connections';
  @override
  VerificationContext validateIntegrity(
    Insertable<GithubConnection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('access_token_encrypted')) {
      context.handle(
        _accessTokenEncryptedMeta,
        accessTokenEncrypted.isAcceptableOrUnknown(
          data['access_token_encrypted']!,
          _accessTokenEncryptedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accessTokenEncryptedMeta);
    }
    if (data.containsKey('refresh_token_encrypted')) {
      context.handle(
        _refreshTokenEncryptedMeta,
        refreshTokenEncrypted.isAcceptableOrUnknown(
          data['refresh_token_encrypted']!,
          _refreshTokenEncryptedMeta,
        ),
      );
    }
    if (data.containsKey('access_token_expires_at')) {
      context.handle(
        _accessTokenExpiresAtMeta,
        accessTokenExpiresAt.isAcceptableOrUnknown(
          data['access_token_expires_at']!,
          _accessTokenExpiresAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  GithubConnection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GithubConnection(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      accessTokenEncrypted: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_token_encrypted'],
      )!,
      refreshTokenEncrypted: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refresh_token_encrypted'],
      ),
      accessTokenExpiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}access_token_expires_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GithubConnectionsTable createAlias(String alias) {
    return $GithubConnectionsTable(attachedDatabase, alias);
  }
}

class GithubConnection extends DataClass
    implements Insertable<GithubConnection> {
  final int userId;
  final String accessTokenEncrypted;
  final String? refreshTokenEncrypted;
  final DateTime? accessTokenExpiresAt;
  final DateTime updatedAt;
  const GithubConnection({
    required this.userId,
    required this.accessTokenEncrypted,
    this.refreshTokenEncrypted,
    this.accessTokenExpiresAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<int>(userId);
    map['access_token_encrypted'] = Variable<String>(accessTokenEncrypted);
    if (!nullToAbsent || refreshTokenEncrypted != null) {
      map['refresh_token_encrypted'] = Variable<String>(refreshTokenEncrypted);
    }
    if (!nullToAbsent || accessTokenExpiresAt != null) {
      map['access_token_expires_at'] = Variable<DateTime>(accessTokenExpiresAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GithubConnectionsCompanion toCompanion(bool nullToAbsent) {
    return GithubConnectionsCompanion(
      userId: Value(userId),
      accessTokenEncrypted: Value(accessTokenEncrypted),
      refreshTokenEncrypted: refreshTokenEncrypted == null && nullToAbsent
          ? const Value.absent()
          : Value(refreshTokenEncrypted),
      accessTokenExpiresAt: accessTokenExpiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(accessTokenExpiresAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GithubConnection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GithubConnection(
      userId: serializer.fromJson<int>(json['userId']),
      accessTokenEncrypted: serializer.fromJson<String>(
        json['accessTokenEncrypted'],
      ),
      refreshTokenEncrypted: serializer.fromJson<String?>(
        json['refreshTokenEncrypted'],
      ),
      accessTokenExpiresAt: serializer.fromJson<DateTime?>(
        json['accessTokenExpiresAt'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<int>(userId),
      'accessTokenEncrypted': serializer.toJson<String>(accessTokenEncrypted),
      'refreshTokenEncrypted': serializer.toJson<String?>(
        refreshTokenEncrypted,
      ),
      'accessTokenExpiresAt': serializer.toJson<DateTime?>(
        accessTokenExpiresAt,
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GithubConnection copyWith({
    int? userId,
    String? accessTokenEncrypted,
    Value<String?> refreshTokenEncrypted = const Value.absent(),
    Value<DateTime?> accessTokenExpiresAt = const Value.absent(),
    DateTime? updatedAt,
  }) => GithubConnection(
    userId: userId ?? this.userId,
    accessTokenEncrypted: accessTokenEncrypted ?? this.accessTokenEncrypted,
    refreshTokenEncrypted: refreshTokenEncrypted.present
        ? refreshTokenEncrypted.value
        : this.refreshTokenEncrypted,
    accessTokenExpiresAt: accessTokenExpiresAt.present
        ? accessTokenExpiresAt.value
        : this.accessTokenExpiresAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GithubConnection copyWithCompanion(GithubConnectionsCompanion data) {
    return GithubConnection(
      userId: data.userId.present ? data.userId.value : this.userId,
      accessTokenEncrypted: data.accessTokenEncrypted.present
          ? data.accessTokenEncrypted.value
          : this.accessTokenEncrypted,
      refreshTokenEncrypted: data.refreshTokenEncrypted.present
          ? data.refreshTokenEncrypted.value
          : this.refreshTokenEncrypted,
      accessTokenExpiresAt: data.accessTokenExpiresAt.present
          ? data.accessTokenExpiresAt.value
          : this.accessTokenExpiresAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GithubConnection(')
          ..write('userId: $userId, ')
          ..write('accessTokenEncrypted: $accessTokenEncrypted, ')
          ..write('refreshTokenEncrypted: $refreshTokenEncrypted, ')
          ..write('accessTokenExpiresAt: $accessTokenExpiresAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    accessTokenEncrypted,
    refreshTokenEncrypted,
    accessTokenExpiresAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GithubConnection &&
          other.userId == this.userId &&
          other.accessTokenEncrypted == this.accessTokenEncrypted &&
          other.refreshTokenEncrypted == this.refreshTokenEncrypted &&
          other.accessTokenExpiresAt == this.accessTokenExpiresAt &&
          other.updatedAt == this.updatedAt);
}

class GithubConnectionsCompanion extends UpdateCompanion<GithubConnection> {
  final Value<int> userId;
  final Value<String> accessTokenEncrypted;
  final Value<String?> refreshTokenEncrypted;
  final Value<DateTime?> accessTokenExpiresAt;
  final Value<DateTime> updatedAt;
  const GithubConnectionsCompanion({
    this.userId = const Value.absent(),
    this.accessTokenEncrypted = const Value.absent(),
    this.refreshTokenEncrypted = const Value.absent(),
    this.accessTokenExpiresAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  GithubConnectionsCompanion.insert({
    this.userId = const Value.absent(),
    required String accessTokenEncrypted,
    this.refreshTokenEncrypted = const Value.absent(),
    this.accessTokenExpiresAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : accessTokenEncrypted = Value(accessTokenEncrypted);
  static Insertable<GithubConnection> custom({
    Expression<int>? userId,
    Expression<String>? accessTokenEncrypted,
    Expression<String>? refreshTokenEncrypted,
    Expression<DateTime>? accessTokenExpiresAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (accessTokenEncrypted != null)
        'access_token_encrypted': accessTokenEncrypted,
      if (refreshTokenEncrypted != null)
        'refresh_token_encrypted': refreshTokenEncrypted,
      if (accessTokenExpiresAt != null)
        'access_token_expires_at': accessTokenExpiresAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  GithubConnectionsCompanion copyWith({
    Value<int>? userId,
    Value<String>? accessTokenEncrypted,
    Value<String?>? refreshTokenEncrypted,
    Value<DateTime?>? accessTokenExpiresAt,
    Value<DateTime>? updatedAt,
  }) {
    return GithubConnectionsCompanion(
      userId: userId ?? this.userId,
      accessTokenEncrypted: accessTokenEncrypted ?? this.accessTokenEncrypted,
      refreshTokenEncrypted:
          refreshTokenEncrypted ?? this.refreshTokenEncrypted,
      accessTokenExpiresAt: accessTokenExpiresAt ?? this.accessTokenExpiresAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (accessTokenEncrypted.present) {
      map['access_token_encrypted'] = Variable<String>(
        accessTokenEncrypted.value,
      );
    }
    if (refreshTokenEncrypted.present) {
      map['refresh_token_encrypted'] = Variable<String>(
        refreshTokenEncrypted.value,
      );
    }
    if (accessTokenExpiresAt.present) {
      map['access_token_expires_at'] = Variable<DateTime>(
        accessTokenExpiresAt.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GithubConnectionsCompanion(')
          ..write('userId: $userId, ')
          ..write('accessTokenEncrypted: $accessTokenEncrypted, ')
          ..write('refreshTokenEncrypted: $refreshTokenEncrypted, ')
          ..write('accessTokenExpiresAt: $accessTokenExpiresAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $RefreshTokensTable refreshTokens = $RefreshTokensTable(this);
  late final $PublishTokensTable publishTokens = $PublishTokensTable(this);
  late final $PackagesTable packages = $PackagesTable(this);
  late final $PackageVersionsTable packageVersions = $PackageVersionsTable(
    this,
  );
  late final $PackageLikesTable packageLikes = $PackageLikesTable(this);
  late final $PackageDownloadDailyTable packageDownloadDaily =
      $PackageDownloadDailyTable(this);
  late final $GithubConnectionsTable githubConnections =
      $GithubConnectionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    refreshTokens,
    publishTokens,
    packages,
    packageVersions,
    packageLikes,
    packageDownloadDaily,
    githubConnections,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String username,
      Value<String?> passwordHash,
      required String role,
      Value<DateTime> createdAt,
      Value<int?> githubId,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String?> passwordHash,
      Value<String> role,
      Value<DateTime> createdAt,
      Value<int?> githubId,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RefreshTokensTable, List<RefreshToken>>
  _refreshTokensRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.refreshTokens,
    aliasName: $_aliasNameGenerator(db.users.id, db.refreshTokens.userId),
  );

  $$RefreshTokensTableProcessedTableManager get refreshTokensRefs {
    final manager = $$RefreshTokensTableTableManager(
      $_db,
      $_db.refreshTokens,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_refreshTokensRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PublishTokensTable, List<PublishToken>>
  _publishTokensRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.publishTokens,
    aliasName: $_aliasNameGenerator(db.users.id, db.publishTokens.userId),
  );

  $$PublishTokensTableProcessedTableManager get publishTokensRefs {
    final manager = $$PublishTokensTableTableManager(
      $_db,
      $_db.publishTokens,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_publishTokensRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PackageVersionsTable, List<PackageVersion>>
  _packageVersionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.packageVersions,
    aliasName: $_aliasNameGenerator(
      db.users.id,
      db.packageVersions.uploaderUserId,
    ),
  );

  $$PackageVersionsTableProcessedTableManager get packageVersionsRefs {
    final manager = $$PackageVersionsTableTableManager(
      $_db,
      $_db.packageVersions,
    ).filter((f) => f.uploaderUserId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _packageVersionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PackageLikesTable, List<PackageLike>>
  _packageLikesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.packageLikes,
    aliasName: $_aliasNameGenerator(db.users.id, db.packageLikes.userId),
  );

  $$PackageLikesTableProcessedTableManager get packageLikesRefs {
    final manager = $$PackageLikesTableTableManager(
      $_db,
      $_db.packageLikes,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_packageLikesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GithubConnectionsTable, List<GithubConnection>>
  _githubConnectionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.githubConnections,
        aliasName: $_aliasNameGenerator(
          db.users.id,
          db.githubConnections.userId,
        ),
      );

  $$GithubConnectionsTableProcessedTableManager get githubConnectionsRefs {
    final manager = $$GithubConnectionsTableTableManager(
      $_db,
      $_db.githubConnections,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _githubConnectionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get githubId => $composableBuilder(
    column: $table.githubId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> refreshTokensRefs(
    Expression<bool> Function($$RefreshTokensTableFilterComposer f) f,
  ) {
    final $$RefreshTokensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.refreshTokens,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RefreshTokensTableFilterComposer(
            $db: $db,
            $table: $db.refreshTokens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> publishTokensRefs(
    Expression<bool> Function($$PublishTokensTableFilterComposer f) f,
  ) {
    final $$PublishTokensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.publishTokens,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PublishTokensTableFilterComposer(
            $db: $db,
            $table: $db.publishTokens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> packageVersionsRefs(
    Expression<bool> Function($$PackageVersionsTableFilterComposer f) f,
  ) {
    final $$PackageVersionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packageVersions,
      getReferencedColumn: (t) => t.uploaderUserId,
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

  Expression<bool> packageLikesRefs(
    Expression<bool> Function($$PackageLikesTableFilterComposer f) f,
  ) {
    final $$PackageLikesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packageLikes,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackageLikesTableFilterComposer(
            $db: $db,
            $table: $db.packageLikes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> githubConnectionsRefs(
    Expression<bool> Function($$GithubConnectionsTableFilterComposer f) f,
  ) {
    final $$GithubConnectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.githubConnections,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GithubConnectionsTableFilterComposer(
            $db: $db,
            $table: $db.githubConnections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get githubId => $composableBuilder(
    column: $table.githubId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get githubId =>
      $composableBuilder(column: $table.githubId, builder: (column) => column);

  Expression<T> refreshTokensRefs<T extends Object>(
    Expression<T> Function($$RefreshTokensTableAnnotationComposer a) f,
  ) {
    final $$RefreshTokensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.refreshTokens,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RefreshTokensTableAnnotationComposer(
            $db: $db,
            $table: $db.refreshTokens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> publishTokensRefs<T extends Object>(
    Expression<T> Function($$PublishTokensTableAnnotationComposer a) f,
  ) {
    final $$PublishTokensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.publishTokens,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PublishTokensTableAnnotationComposer(
            $db: $db,
            $table: $db.publishTokens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> packageVersionsRefs<T extends Object>(
    Expression<T> Function($$PackageVersionsTableAnnotationComposer a) f,
  ) {
    final $$PackageVersionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packageVersions,
      getReferencedColumn: (t) => t.uploaderUserId,
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

  Expression<T> packageLikesRefs<T extends Object>(
    Expression<T> Function($$PackageLikesTableAnnotationComposer a) f,
  ) {
    final $$PackageLikesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packageLikes,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackageLikesTableAnnotationComposer(
            $db: $db,
            $table: $db.packageLikes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> githubConnectionsRefs<T extends Object>(
    Expression<T> Function($$GithubConnectionsTableAnnotationComposer a) f,
  ) {
    final $$GithubConnectionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.githubConnections,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GithubConnectionsTableAnnotationComposer(
                $db: $db,
                $table: $db.githubConnections,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({
            bool refreshTokensRefs,
            bool publishTokensRefs,
            bool packageVersionsRefs,
            bool packageLikesRefs,
            bool githubConnectionsRefs,
          })
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String?> passwordHash = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> githubId = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                username: username,
                passwordHash: passwordHash,
                role: role,
                createdAt: createdAt,
                githubId: githubId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String username,
                Value<String?> passwordHash = const Value.absent(),
                required String role,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> githubId = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                username: username,
                passwordHash: passwordHash,
                role: role,
                createdAt: createdAt,
                githubId: githubId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                refreshTokensRefs = false,
                publishTokensRefs = false,
                packageVersionsRefs = false,
                packageLikesRefs = false,
                githubConnectionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (refreshTokensRefs) db.refreshTokens,
                    if (publishTokensRefs) db.publishTokens,
                    if (packageVersionsRefs) db.packageVersions,
                    if (packageLikesRefs) db.packageLikes,
                    if (githubConnectionsRefs) db.githubConnections,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (refreshTokensRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          RefreshToken
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._refreshTokensRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).refreshTokensRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (publishTokensRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          PublishToken
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._publishTokensRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).publishTokensRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (packageVersionsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          PackageVersion
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._packageVersionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).packageVersionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.uploaderUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (packageLikesRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          PackageLike
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._packageLikesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).packageLikesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (githubConnectionsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          GithubConnection
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._githubConnectionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).githubConnectionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
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

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({
        bool refreshTokensRefs,
        bool publishTokensRefs,
        bool packageVersionsRefs,
        bool packageLikesRefs,
        bool githubConnectionsRefs,
      })
    >;
typedef $$RefreshTokensTableCreateCompanionBuilder =
    RefreshTokensCompanion Function({
      Value<int> id,
      required int userId,
      required String tokenHash,
      Value<DateTime> createdAt,
      required DateTime expiresAt,
      Value<DateTime?> revokedAt,
    });
typedef $$RefreshTokensTableUpdateCompanionBuilder =
    RefreshTokensCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> tokenHash,
      Value<DateTime> createdAt,
      Value<DateTime> expiresAt,
      Value<DateTime?> revokedAt,
    });

final class $$RefreshTokensTableReferences
    extends BaseReferences<_$AppDatabase, $RefreshTokensTable, RefreshToken> {
  $$RefreshTokensTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.refreshTokens.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RefreshTokensTableFilterComposer
    extends Composer<_$AppDatabase, $RefreshTokensTable> {
  $$RefreshTokensTableFilterComposer({
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

  ColumnFilters<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get revokedAt => $composableBuilder(
    column: $table.revokedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefreshTokensTableOrderingComposer
    extends Composer<_$AppDatabase, $RefreshTokensTable> {
  $$RefreshTokensTableOrderingComposer({
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

  ColumnOrderings<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get revokedAt => $composableBuilder(
    column: $table.revokedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefreshTokensTableAnnotationComposer
    extends Composer<_$AppDatabase, $RefreshTokensTable> {
  $$RefreshTokensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokenHash =>
      $composableBuilder(column: $table.tokenHash, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get revokedAt =>
      $composableBuilder(column: $table.revokedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefreshTokensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RefreshTokensTable,
          RefreshToken,
          $$RefreshTokensTableFilterComposer,
          $$RefreshTokensTableOrderingComposer,
          $$RefreshTokensTableAnnotationComposer,
          $$RefreshTokensTableCreateCompanionBuilder,
          $$RefreshTokensTableUpdateCompanionBuilder,
          (RefreshToken, $$RefreshTokensTableReferences),
          RefreshToken,
          PrefetchHooks Function({bool userId})
        > {
  $$RefreshTokensTableTableManager(_$AppDatabase db, $RefreshTokensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RefreshTokensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RefreshTokensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RefreshTokensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> tokenHash = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<DateTime?> revokedAt = const Value.absent(),
              }) => RefreshTokensCompanion(
                id: id,
                userId: userId,
                tokenHash: tokenHash,
                createdAt: createdAt,
                expiresAt: expiresAt,
                revokedAt: revokedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String tokenHash,
                Value<DateTime> createdAt = const Value.absent(),
                required DateTime expiresAt,
                Value<DateTime?> revokedAt = const Value.absent(),
              }) => RefreshTokensCompanion.insert(
                id: id,
                userId: userId,
                tokenHash: tokenHash,
                createdAt: createdAt,
                expiresAt: expiresAt,
                revokedAt: revokedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RefreshTokensTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
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
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$RefreshTokensTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$RefreshTokensTableReferences
                                    ._userIdTable(db)
                                    .id,
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

typedef $$RefreshTokensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RefreshTokensTable,
      RefreshToken,
      $$RefreshTokensTableFilterComposer,
      $$RefreshTokensTableOrderingComposer,
      $$RefreshTokensTableAnnotationComposer,
      $$RefreshTokensTableCreateCompanionBuilder,
      $$RefreshTokensTableUpdateCompanionBuilder,
      (RefreshToken, $$RefreshTokensTableReferences),
      RefreshToken,
      PrefetchHooks Function({bool userId})
    >;
typedef $$PublishTokensTableCreateCompanionBuilder =
    PublishTokensCompanion Function({
      Value<int> id,
      required int userId,
      required String tokenHash,
      Value<DateTime> createdAt,
      Value<DateTime?> lastUsedAt,
      Value<DateTime?> revokedAt,
    });
typedef $$PublishTokensTableUpdateCompanionBuilder =
    PublishTokensCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> tokenHash,
      Value<DateTime> createdAt,
      Value<DateTime?> lastUsedAt,
      Value<DateTime?> revokedAt,
    });

final class $$PublishTokensTableReferences
    extends BaseReferences<_$AppDatabase, $PublishTokensTable, PublishToken> {
  $$PublishTokensTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.publishTokens.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PackageVersionsTable, List<PackageVersion>>
  _packageVersionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.packageVersions,
    aliasName: $_aliasNameGenerator(
      db.publishTokens.id,
      db.packageVersions.uploaderTokenId,
    ),
  );

  $$PackageVersionsTableProcessedTableManager get packageVersionsRefs {
    final manager = $$PackageVersionsTableTableManager(
      $_db,
      $_db.packageVersions,
    ).filter((f) => f.uploaderTokenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _packageVersionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PublishTokensTableFilterComposer
    extends Composer<_$AppDatabase, $PublishTokensTable> {
  $$PublishTokensTableFilterComposer({
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

  ColumnFilters<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get revokedAt => $composableBuilder(
    column: $table.revokedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> packageVersionsRefs(
    Expression<bool> Function($$PackageVersionsTableFilterComposer f) f,
  ) {
    final $$PackageVersionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packageVersions,
      getReferencedColumn: (t) => t.uploaderTokenId,
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

class $$PublishTokensTableOrderingComposer
    extends Composer<_$AppDatabase, $PublishTokensTable> {
  $$PublishTokensTableOrderingComposer({
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

  ColumnOrderings<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get revokedAt => $composableBuilder(
    column: $table.revokedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PublishTokensTableAnnotationComposer
    extends Composer<_$AppDatabase, $PublishTokensTable> {
  $$PublishTokensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokenHash =>
      $composableBuilder(column: $table.tokenHash, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get revokedAt =>
      $composableBuilder(column: $table.revokedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> packageVersionsRefs<T extends Object>(
    Expression<T> Function($$PackageVersionsTableAnnotationComposer a) f,
  ) {
    final $$PackageVersionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packageVersions,
      getReferencedColumn: (t) => t.uploaderTokenId,
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

class $$PublishTokensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PublishTokensTable,
          PublishToken,
          $$PublishTokensTableFilterComposer,
          $$PublishTokensTableOrderingComposer,
          $$PublishTokensTableAnnotationComposer,
          $$PublishTokensTableCreateCompanionBuilder,
          $$PublishTokensTableUpdateCompanionBuilder,
          (PublishToken, $$PublishTokensTableReferences),
          PublishToken,
          PrefetchHooks Function({bool userId, bool packageVersionsRefs})
        > {
  $$PublishTokensTableTableManager(_$AppDatabase db, $PublishTokensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PublishTokensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PublishTokensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PublishTokensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> tokenHash = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<DateTime?> revokedAt = const Value.absent(),
              }) => PublishTokensCompanion(
                id: id,
                userId: userId,
                tokenHash: tokenHash,
                createdAt: createdAt,
                lastUsedAt: lastUsedAt,
                revokedAt: revokedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String tokenHash,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<DateTime?> revokedAt = const Value.absent(),
              }) => PublishTokensCompanion.insert(
                id: id,
                userId: userId,
                tokenHash: tokenHash,
                createdAt: createdAt,
                lastUsedAt: lastUsedAt,
                revokedAt: revokedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PublishTokensTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({userId = false, packageVersionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (packageVersionsRefs) db.packageVersions,
                  ],
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
                        if (userId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.userId,
                                    referencedTable:
                                        $$PublishTokensTableReferences
                                            ._userIdTable(db),
                                    referencedColumn:
                                        $$PublishTokensTableReferences
                                            ._userIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (packageVersionsRefs)
                        await $_getPrefetchedData<
                          PublishToken,
                          $PublishTokensTable,
                          PackageVersion
                        >(
                          currentTable: table,
                          referencedTable: $$PublishTokensTableReferences
                              ._packageVersionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PublishTokensTableReferences(
                                db,
                                table,
                                p0,
                              ).packageVersionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.uploaderTokenId == item.id,
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

typedef $$PublishTokensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PublishTokensTable,
      PublishToken,
      $$PublishTokensTableFilterComposer,
      $$PublishTokensTableOrderingComposer,
      $$PublishTokensTableAnnotationComposer,
      $$PublishTokensTableCreateCompanionBuilder,
      $$PublishTokensTableUpdateCompanionBuilder,
      (PublishToken, $$PublishTokensTableReferences),
      PublishToken,
      PrefetchHooks Function({bool userId, bool packageVersionsRefs})
    >;
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

  static MultiTypedResultKey<$PackageLikesTable, List<PackageLike>>
  _packageLikesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.packageLikes,
    aliasName: $_aliasNameGenerator(
      db.packages.name,
      db.packageLikes.packageName,
    ),
  );

  $$PackageLikesTableProcessedTableManager get packageLikesRefs {
    final manager = $$PackageLikesTableTableManager($_db, $_db.packageLikes)
        .filter(
          (f) => f.packageName.name.sqlEquals($_itemColumn<String>('name')!),
        );

    final cache = $_typedResult.readTableOrNull(_packageLikesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PackageDownloadDailyTable,
    List<PackageDownloadDailyData>
  >
  _packageDownloadDailyRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.packageDownloadDaily,
        aliasName: $_aliasNameGenerator(
          db.packages.name,
          db.packageDownloadDaily.packageName,
        ),
      );

  $$PackageDownloadDailyTableProcessedTableManager
  get packageDownloadDailyRefs {
    final manager =
        $$PackageDownloadDailyTableTableManager(
          $_db,
          $_db.packageDownloadDaily,
        ).filter(
          (f) => f.packageName.name.sqlEquals($_itemColumn<String>('name')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _packageDownloadDailyRefsTable($_db),
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

  Expression<bool> packageLikesRefs(
    Expression<bool> Function($$PackageLikesTableFilterComposer f) f,
  ) {
    final $$PackageLikesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.name,
      referencedTable: $db.packageLikes,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackageLikesTableFilterComposer(
            $db: $db,
            $table: $db.packageLikes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> packageDownloadDailyRefs(
    Expression<bool> Function($$PackageDownloadDailyTableFilterComposer f) f,
  ) {
    final $$PackageDownloadDailyTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.name,
      referencedTable: $db.packageDownloadDaily,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackageDownloadDailyTableFilterComposer(
            $db: $db,
            $table: $db.packageDownloadDaily,
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

  Expression<T> packageLikesRefs<T extends Object>(
    Expression<T> Function($$PackageLikesTableAnnotationComposer a) f,
  ) {
    final $$PackageLikesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.name,
      referencedTable: $db.packageLikes,
      getReferencedColumn: (t) => t.packageName,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PackageLikesTableAnnotationComposer(
            $db: $db,
            $table: $db.packageLikes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> packageDownloadDailyRefs<T extends Object>(
    Expression<T> Function($$PackageDownloadDailyTableAnnotationComposer a) f,
  ) {
    final $$PackageDownloadDailyTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.name,
          referencedTable: $db.packageDownloadDaily,
          getReferencedColumn: (t) => t.packageName,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PackageDownloadDailyTableAnnotationComposer(
                $db: $db,
                $table: $db.packageDownloadDaily,
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
          PrefetchHooks Function({
            bool packageVersionsRefs,
            bool packageLikesRefs,
            bool packageDownloadDailyRefs,
          })
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
          prefetchHooksCallback:
              ({
                packageVersionsRefs = false,
                packageLikesRefs = false,
                packageDownloadDailyRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (packageVersionsRefs) db.packageVersions,
                    if (packageLikesRefs) db.packageLikes,
                    if (packageDownloadDailyRefs) db.packageDownloadDaily,
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
                          managerFromTypedResult: (p0) =>
                              $$PackagesTableReferences(
                                db,
                                table,
                                p0,
                              ).packageVersionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.packageName == item.name,
                              ),
                          typedResults: items,
                        ),
                      if (packageLikesRefs)
                        await $_getPrefetchedData<
                          Package,
                          $PackagesTable,
                          PackageLike
                        >(
                          currentTable: table,
                          referencedTable: $$PackagesTableReferences
                              ._packageLikesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PackagesTableReferences(
                                db,
                                table,
                                p0,
                              ).packageLikesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.packageName == item.name,
                              ),
                          typedResults: items,
                        ),
                      if (packageDownloadDailyRefs)
                        await $_getPrefetchedData<
                          Package,
                          $PackagesTable,
                          PackageDownloadDailyData
                        >(
                          currentTable: table,
                          referencedTable: $$PackagesTableReferences
                              ._packageDownloadDailyRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PackagesTableReferences(
                                db,
                                table,
                                p0,
                              ).packageDownloadDailyRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
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
      PrefetchHooks Function({
        bool packageVersionsRefs,
        bool packageLikesRefs,
        bool packageDownloadDailyRefs,
      })
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
      Value<int?> uploaderTokenId,
      Value<int?> uploaderUserId,
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
      Value<int?> uploaderTokenId,
      Value<int?> uploaderUserId,
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

  static $PublishTokensTable _uploaderTokenIdTable(_$AppDatabase db) =>
      db.publishTokens.createAlias(
        $_aliasNameGenerator(
          db.packageVersions.uploaderTokenId,
          db.publishTokens.id,
        ),
      );

  $$PublishTokensTableProcessedTableManager? get uploaderTokenId {
    final $_column = $_itemColumn<int>('uploader_token_id');
    if ($_column == null) return null;
    final manager = $$PublishTokensTableTableManager(
      $_db,
      $_db.publishTokens,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_uploaderTokenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _uploaderUserIdTable(_$AppDatabase db) =>
      db.users.createAlias(
        $_aliasNameGenerator(db.packageVersions.uploaderUserId, db.users.id),
      );

  $$UsersTableProcessedTableManager? get uploaderUserId {
    final $_column = $_itemColumn<int>('uploader_user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_uploaderUserIdTable($_db));
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

  $$PublishTokensTableFilterComposer get uploaderTokenId {
    final $$PublishTokensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uploaderTokenId,
      referencedTable: $db.publishTokens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PublishTokensTableFilterComposer(
            $db: $db,
            $table: $db.publishTokens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get uploaderUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uploaderUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
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

  $$PublishTokensTableOrderingComposer get uploaderTokenId {
    final $$PublishTokensTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uploaderTokenId,
      referencedTable: $db.publishTokens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PublishTokensTableOrderingComposer(
            $db: $db,
            $table: $db.publishTokens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get uploaderUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uploaderUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
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

  $$PublishTokensTableAnnotationComposer get uploaderTokenId {
    final $$PublishTokensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uploaderTokenId,
      referencedTable: $db.publishTokens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PublishTokensTableAnnotationComposer(
            $db: $db,
            $table: $db.publishTokens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get uploaderUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uploaderUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
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
          PrefetchHooks Function({
            bool packageName,
            bool uploaderTokenId,
            bool uploaderUserId,
          })
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
                Value<int?> uploaderTokenId = const Value.absent(),
                Value<int?> uploaderUserId = const Value.absent(),
              }) => PackageVersionsCompanion(
                id: id,
                packageName: packageName,
                version: version,
                pubspecYaml: pubspecYaml,
                archiveSha256: archiveSha256,
                archivePath: archivePath,
                uploadedAt: uploadedAt,
                uploaderTokenId: uploaderTokenId,
                uploaderUserId: uploaderUserId,
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
                Value<int?> uploaderTokenId = const Value.absent(),
                Value<int?> uploaderUserId = const Value.absent(),
              }) => PackageVersionsCompanion.insert(
                id: id,
                packageName: packageName,
                version: version,
                pubspecYaml: pubspecYaml,
                archiveSha256: archiveSha256,
                archivePath: archivePath,
                uploadedAt: uploadedAt,
                uploaderTokenId: uploaderTokenId,
                uploaderUserId: uploaderUserId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PackageVersionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                packageName = false,
                uploaderTokenId = false,
                uploaderUserId = false,
              }) {
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
                        if (uploaderTokenId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.uploaderTokenId,
                                    referencedTable:
                                        $$PackageVersionsTableReferences
                                            ._uploaderTokenIdTable(db),
                                    referencedColumn:
                                        $$PackageVersionsTableReferences
                                            ._uploaderTokenIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (uploaderUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.uploaderUserId,
                                    referencedTable:
                                        $$PackageVersionsTableReferences
                                            ._uploaderUserIdTable(db),
                                    referencedColumn:
                                        $$PackageVersionsTableReferences
                                            ._uploaderUserIdTable(db)
                                            .id,
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
      PrefetchHooks Function({
        bool packageName,
        bool uploaderTokenId,
        bool uploaderUserId,
      })
    >;
typedef $$PackageLikesTableCreateCompanionBuilder =
    PackageLikesCompanion Function({
      required String packageName,
      required int userId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$PackageLikesTableUpdateCompanionBuilder =
    PackageLikesCompanion Function({
      Value<String> packageName,
      Value<int> userId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PackageLikesTableReferences
    extends BaseReferences<_$AppDatabase, $PackageLikesTable, PackageLike> {
  $$PackageLikesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PackagesTable _packageNameTable(_$AppDatabase db) =>
      db.packages.createAlias(
        $_aliasNameGenerator(db.packageLikes.packageName, db.packages.name),
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

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.packageLikes.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PackageLikesTableFilterComposer
    extends Composer<_$AppDatabase, $PackageLikesTable> {
  $$PackageLikesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackageLikesTableOrderingComposer
    extends Composer<_$AppDatabase, $PackageLikesTable> {
  $$PackageLikesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackageLikesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PackageLikesTable> {
  $$PackageLikesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PackageLikesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PackageLikesTable,
          PackageLike,
          $$PackageLikesTableFilterComposer,
          $$PackageLikesTableOrderingComposer,
          $$PackageLikesTableAnnotationComposer,
          $$PackageLikesTableCreateCompanionBuilder,
          $$PackageLikesTableUpdateCompanionBuilder,
          (PackageLike, $$PackageLikesTableReferences),
          PackageLike,
          PrefetchHooks Function({bool packageName, bool userId})
        > {
  $$PackageLikesTableTableManager(_$AppDatabase db, $PackageLikesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackageLikesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackageLikesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PackageLikesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packageName = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PackageLikesCompanion(
                packageName: packageName,
                userId: userId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packageName,
                required int userId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PackageLikesCompanion.insert(
                packageName: packageName,
                userId: userId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PackageLikesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packageName = false, userId = false}) {
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
                                referencedTable: $$PackageLikesTableReferences
                                    ._packageNameTable(db),
                                referencedColumn: $$PackageLikesTableReferences
                                    ._packageNameTable(db)
                                    .name,
                              )
                              as T;
                    }
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$PackageLikesTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$PackageLikesTableReferences
                                    ._userIdTable(db)
                                    .id,
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

typedef $$PackageLikesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PackageLikesTable,
      PackageLike,
      $$PackageLikesTableFilterComposer,
      $$PackageLikesTableOrderingComposer,
      $$PackageLikesTableAnnotationComposer,
      $$PackageLikesTableCreateCompanionBuilder,
      $$PackageLikesTableUpdateCompanionBuilder,
      (PackageLike, $$PackageLikesTableReferences),
      PackageLike,
      PrefetchHooks Function({bool packageName, bool userId})
    >;
typedef $$PackageDownloadDailyTableCreateCompanionBuilder =
    PackageDownloadDailyCompanion Function({
      required String packageName,
      required String day,
      Value<int> count,
      Value<int> rowid,
    });
typedef $$PackageDownloadDailyTableUpdateCompanionBuilder =
    PackageDownloadDailyCompanion Function({
      Value<String> packageName,
      Value<String> day,
      Value<int> count,
      Value<int> rowid,
    });

final class $$PackageDownloadDailyTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PackageDownloadDailyTable,
          PackageDownloadDailyData
        > {
  $$PackageDownloadDailyTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PackagesTable _packageNameTable(_$AppDatabase db) =>
      db.packages.createAlias(
        $_aliasNameGenerator(
          db.packageDownloadDaily.packageName,
          db.packages.name,
        ),
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

class $$PackageDownloadDailyTableFilterComposer
    extends Composer<_$AppDatabase, $PackageDownloadDailyTable> {
  $$PackageDownloadDailyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
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

class $$PackageDownloadDailyTableOrderingComposer
    extends Composer<_$AppDatabase, $PackageDownloadDailyTable> {
  $$PackageDownloadDailyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
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

class $$PackageDownloadDailyTableAnnotationComposer
    extends Composer<_$AppDatabase, $PackageDownloadDailyTable> {
  $$PackageDownloadDailyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

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

class $$PackageDownloadDailyTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PackageDownloadDailyTable,
          PackageDownloadDailyData,
          $$PackageDownloadDailyTableFilterComposer,
          $$PackageDownloadDailyTableOrderingComposer,
          $$PackageDownloadDailyTableAnnotationComposer,
          $$PackageDownloadDailyTableCreateCompanionBuilder,
          $$PackageDownloadDailyTableUpdateCompanionBuilder,
          (PackageDownloadDailyData, $$PackageDownloadDailyTableReferences),
          PackageDownloadDailyData,
          PrefetchHooks Function({bool packageName})
        > {
  $$PackageDownloadDailyTableTableManager(
    _$AppDatabase db,
    $PackageDownloadDailyTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackageDownloadDailyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackageDownloadDailyTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PackageDownloadDailyTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> packageName = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PackageDownloadDailyCompanion(
                packageName: packageName,
                day: day,
                count: count,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packageName,
                required String day,
                Value<int> count = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PackageDownloadDailyCompanion.insert(
                packageName: packageName,
                day: day,
                count: count,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PackageDownloadDailyTableReferences(db, table, e),
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
                                    $$PackageDownloadDailyTableReferences
                                        ._packageNameTable(db),
                                referencedColumn:
                                    $$PackageDownloadDailyTableReferences
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

typedef $$PackageDownloadDailyTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PackageDownloadDailyTable,
      PackageDownloadDailyData,
      $$PackageDownloadDailyTableFilterComposer,
      $$PackageDownloadDailyTableOrderingComposer,
      $$PackageDownloadDailyTableAnnotationComposer,
      $$PackageDownloadDailyTableCreateCompanionBuilder,
      $$PackageDownloadDailyTableUpdateCompanionBuilder,
      (PackageDownloadDailyData, $$PackageDownloadDailyTableReferences),
      PackageDownloadDailyData,
      PrefetchHooks Function({bool packageName})
    >;
typedef $$GithubConnectionsTableCreateCompanionBuilder =
    GithubConnectionsCompanion Function({
      Value<int> userId,
      required String accessTokenEncrypted,
      Value<String?> refreshTokenEncrypted,
      Value<DateTime?> accessTokenExpiresAt,
      Value<DateTime> updatedAt,
    });
typedef $$GithubConnectionsTableUpdateCompanionBuilder =
    GithubConnectionsCompanion Function({
      Value<int> userId,
      Value<String> accessTokenEncrypted,
      Value<String?> refreshTokenEncrypted,
      Value<DateTime?> accessTokenExpiresAt,
      Value<DateTime> updatedAt,
    });

final class $$GithubConnectionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GithubConnectionsTable,
          GithubConnection
        > {
  $$GithubConnectionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.githubConnections.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GithubConnectionsTableFilterComposer
    extends Composer<_$AppDatabase, $GithubConnectionsTable> {
  $$GithubConnectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get accessTokenEncrypted => $composableBuilder(
    column: $table.accessTokenEncrypted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refreshTokenEncrypted => $composableBuilder(
    column: $table.refreshTokenEncrypted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get accessTokenExpiresAt => $composableBuilder(
    column: $table.accessTokenExpiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GithubConnectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $GithubConnectionsTable> {
  $$GithubConnectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get accessTokenEncrypted => $composableBuilder(
    column: $table.accessTokenEncrypted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refreshTokenEncrypted => $composableBuilder(
    column: $table.refreshTokenEncrypted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get accessTokenExpiresAt => $composableBuilder(
    column: $table.accessTokenExpiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GithubConnectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GithubConnectionsTable> {
  $$GithubConnectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get accessTokenEncrypted => $composableBuilder(
    column: $table.accessTokenEncrypted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refreshTokenEncrypted => $composableBuilder(
    column: $table.refreshTokenEncrypted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get accessTokenExpiresAt => $composableBuilder(
    column: $table.accessTokenExpiresAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GithubConnectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GithubConnectionsTable,
          GithubConnection,
          $$GithubConnectionsTableFilterComposer,
          $$GithubConnectionsTableOrderingComposer,
          $$GithubConnectionsTableAnnotationComposer,
          $$GithubConnectionsTableCreateCompanionBuilder,
          $$GithubConnectionsTableUpdateCompanionBuilder,
          (GithubConnection, $$GithubConnectionsTableReferences),
          GithubConnection,
          PrefetchHooks Function({bool userId})
        > {
  $$GithubConnectionsTableTableManager(
    _$AppDatabase db,
    $GithubConnectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GithubConnectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GithubConnectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GithubConnectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> userId = const Value.absent(),
                Value<String> accessTokenEncrypted = const Value.absent(),
                Value<String?> refreshTokenEncrypted = const Value.absent(),
                Value<DateTime?> accessTokenExpiresAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => GithubConnectionsCompanion(
                userId: userId,
                accessTokenEncrypted: accessTokenEncrypted,
                refreshTokenEncrypted: refreshTokenEncrypted,
                accessTokenExpiresAt: accessTokenExpiresAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> userId = const Value.absent(),
                required String accessTokenEncrypted,
                Value<String?> refreshTokenEncrypted = const Value.absent(),
                Value<DateTime?> accessTokenExpiresAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => GithubConnectionsCompanion.insert(
                userId: userId,
                accessTokenEncrypted: accessTokenEncrypted,
                refreshTokenEncrypted: refreshTokenEncrypted,
                accessTokenExpiresAt: accessTokenExpiresAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GithubConnectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
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
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable:
                                    $$GithubConnectionsTableReferences
                                        ._userIdTable(db),
                                referencedColumn:
                                    $$GithubConnectionsTableReferences
                                        ._userIdTable(db)
                                        .id,
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

typedef $$GithubConnectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GithubConnectionsTable,
      GithubConnection,
      $$GithubConnectionsTableFilterComposer,
      $$GithubConnectionsTableOrderingComposer,
      $$GithubConnectionsTableAnnotationComposer,
      $$GithubConnectionsTableCreateCompanionBuilder,
      $$GithubConnectionsTableUpdateCompanionBuilder,
      (GithubConnection, $$GithubConnectionsTableReferences),
      GithubConnection,
      PrefetchHooks Function({bool userId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$RefreshTokensTableTableManager get refreshTokens =>
      $$RefreshTokensTableTableManager(_db, _db.refreshTokens);
  $$PublishTokensTableTableManager get publishTokens =>
      $$PublishTokensTableTableManager(_db, _db.publishTokens);
  $$PackagesTableTableManager get packages =>
      $$PackagesTableTableManager(_db, _db.packages);
  $$PackageVersionsTableTableManager get packageVersions =>
      $$PackageVersionsTableTableManager(_db, _db.packageVersions);
  $$PackageLikesTableTableManager get packageLikes =>
      $$PackageLikesTableTableManager(_db, _db.packageLikes);
  $$PackageDownloadDailyTableTableManager get packageDownloadDaily =>
      $$PackageDownloadDailyTableTableManager(_db, _db.packageDownloadDaily);
  $$GithubConnectionsTableTableManager get githubConnections =>
      $$GithubConnectionsTableTableManager(_db, _db.githubConnections);
}
