import 'package:admin_backend/domain.dart';
import 'package:postgres/postgres.dart';

const _tableName = 'admin_profile';

// CREATE TABLE admin_profile (
//   id UUID PRIMARY KEY,
//   account_id UUID UNIQUE NOT NULL,
//   name TEXT NOT NULL,
//   FOREIGN KEY (account_id) REFERENCES admin_account(id) ON DELETE CASCADE
// )

class AdminProfileManager {
  AdminProfileManager(this._connection);

  final Connection _connection;

  Future<AdminProfile> getByAccountIdOrCreate(AccountId accountId) async {
    final result = await _connection.execute(
      Sql.named(
        'SELECT name FROM $_tableName WHERE account_id=@accountId',
      ),
      parameters: {'accountId': '$accountId'},
    );

    if (result.isEmpty) {
      final unnamedName = 'Unnamed Admin';

      await _connection.execute(
        Sql.named(
          'INSERT INTO $_tableName (id, account_id, name) VALUES (gen_random_uuid(), @accountId, @name)',
        ),
        parameters: {
          'accountId': '$accountId',
          'name': unnamedName,
        },
      );
      return AdminProfile(
        accountId: accountId,
        name: unnamedName,
      );
    }

    final name = result[0][0] as String;
    return AdminProfile(
      accountId: accountId,
      name: name,
    );
  }
}
