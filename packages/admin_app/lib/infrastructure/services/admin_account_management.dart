import 'package:admin_app/domain.dart';
import 'package:admin_app/infrastructure.dart';

final class AdminAccountManagementServiceImpl
    implements AdminAccountManagementService {
  AdminAccountManagementServiceImpl(this._dio);

  final Dio _dio;

  Future<DataOrFailure<AdminAccount>> createAccount({
    required String email,
    required String password,
    required List<AdminAccountPermission> permissions,
  }) {
    return _dio.post('/sign-up', data: {
      'email': email,
      'password': password,
      'permissions': permissions.map((e) => e.name).toList(),
    }).toData((r) => AdminAccount.fromJson(r));
  }

  Future<ListDataOrFailure<AdminAccount>> getAccounts() {
    return _dio
        .get('/account')
        .toListData((r) => r.map((e) => AdminAccount.fromJson(e)).toList());
  }

  Future<DataOrFailure<AdminAccount>> getAccount({
    required UuidValue id,
  }) {
    return _dio.get('/account/$id').toData((r) => AdminAccount.fromJson(r));
  }

  Future<DataOrFailure<AdminAccount>> updateAccount({
    required UuidValue id,
    required String email,
    required String password,
    required List<AdminAccountPermission> permissions,
  }) {
    return _dio.put('/account/$id', data: {
      'email': email,
      'password': password,
      'permissions': permissions.map((e) => e.name).toList(),
    }).toData((r) => AdminAccount.fromJson(r));
  }

  Future<SuccessOrFailure> deleteAccount({
    required UuidValue id,
  }) {
    return _dio.delete('/account/$id').toSuccess();
  }
}
