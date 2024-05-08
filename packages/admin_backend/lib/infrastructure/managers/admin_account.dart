import 'dart:convert';

import 'package:admin_backend/domain.dart';
import 'package:postgres/postgres.dart';
import 'package:crypto/crypto.dart';

const _tableName = 'admin_account';

// CREATE TABLE admin_account (
//   id UUID PRIMARY KEY,
//   email TEXT NOT NULL,
//   password TEXT NOT NULL,
//   permissions TEXT[] NOT NULL
// );

const _salt = 'fp1jdp12dj120ibds21js21sj12-snb1ouh43-gi23=0dQ*)Q@Y*()(#*!@)*#';

String _hashPassword(String password) {
  final combined = utf8.encode(password + _salt);
  final digest = sha256.convert(combined);
  return base64Encode(digest.bytes);
}

AdminAccount? _rowToAdminAccount(List row) {
  if (row.isEmpty) return null;

  return AdminAccount(
    id: UuidValue.fromString(row[0] as String),
    email: row[1] as String,
    permissions: (row[3] as List<String>)
        .map((e) => AdminAccountPermission.values.byName(e))
        .toList(),
  );
}

class AdminAccountManager {
  AdminAccountManager(this._connection);

  final Connection _connection;

  _AdminAccountManagerOfEntity of(AdminAccount entity) {
    return _AdminAccountManagerOfEntity(_connection, entity);
  }

  Future<AdminAccount> create({
    required String email,
    required String password,
    required List<AdminAccountPermission> permissions,
  }) async {
    final id = Uuid().v4obj();
    await _connection.execute(
      Sql.named(
        'INSERT INTO $_tableName (id, email, password, permissions) VALUES (@id, @email, @password, @permissions)',
      ),
      parameters: {
        'id': '$id',
        'email': email,
        'password': _hashPassword(password),
        'permissions': permissions.map((e) => e.name).toList(),
      },
    );
    return AdminAccount(
      id: id,
      email: email,
      permissions: permissions,
    );
  }

  Future<List<AdminAccount>> getAll() async {
    final result = await _connection.execute(
      Sql.named('SELECT * FROM $_tableName'),
    );

    return result.map((e) => _rowToAdminAccount(e)!).toList();
  }

  Future<AdminAccount?> getByCredentialsOrNull(
    String email,
    String password,
  ) async {
    final result = await _connection.execute(
      Sql.named(
          'SELECT * FROM $_tableName WHERE email=@email AND password=@password'),
      parameters: {'email': email, 'password': _hashPassword(password)},
    );

    if (result.isEmpty) {
      return null;
    }

    return _rowToAdminAccount(result[0]);
  }

  Future<AdminAccount?> getByEmailOrNull(String email) async {
    final result = await _connection.execute(
      Sql.named('SELECT * FROM $_tableName WHERE email=@email'),
      parameters: {'email': email},
    );

    if (result.isEmpty) {
      return null;
    }

    return _rowToAdminAccount(result[0]);
  }

  Future<AdminAccount?> getByIdOrNull(AccountId id) async {
    final result = await _connection.execute(
      Sql.named('SELECT * FROM $_tableName WHERE id=@id'),
      parameters: {'id': '$id'},
    );

    if (result.isEmpty) {
      return null;
    }

    return _rowToAdminAccount(result[0]);
  }
}

final class _AdminAccountManagerOfEntity {
  _AdminAccountManagerOfEntity(this._connection, this._entity);

  final Connection _connection;
  final AdminAccount _entity;

  Future<AdminAccount> update({
    required String email,
    String? password,
    required List<AdminAccountPermission> permissions,
  }) async {
    final passwordParameter = password == null ? '' : ', password=@password';
    await _connection.execute(
      Sql.named(
        'UPDATE $_tableName SET email=@email$passwordParameter, permissions=@permissions WHERE id=@id',
      ),
      parameters: {
        'id': '$_entity.id',
        'email': email,
        if (password != null) 'password': _hashPassword(password),
        'permissions': permissions.map((e) => e.toString()).toList(),
      },
    );

    return AdminAccount(
      id: _entity.id,
      email: email,
      permissions: permissions,
    );
  }

  Future<void> delete() async {
    await _connection.execute(
      Sql.named('DELETE FROM $_tableName WHERE id=@id'),
      parameters: {'id': '${_entity.id}'},
    );
  }
}
