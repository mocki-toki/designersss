import 'dart:math';

import 'package:admin_backend/domain.dart';
import 'package:postgres/postgres.dart';

const _tableName = 'admin_session';

// CREATE TABLE admin_session (
//   id UUID PRIMARY KEY,
//   account_id UUID UNIQUE NOT NULL,
//   token TEXT NOT NULL,
//   expires TIMESTAMPTZ NOT NULL,
//   FOREIGN KEY (account_id) REFERENCES admin_account(id) ON DELETE CASCADE
// );

class AdminSessionManager {
  AdminSessionManager(this._connection);

  final Connection _connection;

  Future<AdminSession> create(AccountId accountId) async {
    final token = _getRandomString();
    final expires = DateTime.now().add(const Duration(hours: 8));

    await _connection.execute(
      Sql.named(
        'INSERT INTO $_tableName (id, account_id, token, expires) VALUES (gen_random_uuid(), @accountId, @token, @expires)',
      ),
      parameters: {
        'accountId': '$accountId',
        'token': '$token',
        'expires': expires.toUtc(),
      },
    );
    return AdminSession(
      accountId: accountId,
      token: token,
      expires: expires,
    );
  }

  Future<AdminSession?> getByTokenOrNull(Token token) async {
    final result = await _connection.execute(
      Sql.named(
        'SELECT account_id, expires FROM $_tableName WHERE token=@token',
      ),
      parameters: {'token': '$token'},
    );

    if (result.isEmpty) return null;

    final accountId = result[0][0] as String;
    final expires = result[0][1] as DateTime;
    return AdminSession(
      accountId: AccountId.fromString(accountId),
      token: token,
      expires: expires,
    );
  }

  Future<void> deleteByAccountId(AccountId accountId) async {
    await _connection.execute(
      Sql.named('DELETE FROM $_tableName WHERE account_id=@accountId'),
      parameters: {'accountId': '$accountId'},
    );
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random.secure();

String _getRandomString() => String.fromCharCodes(Iterable.generate(
    50, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
