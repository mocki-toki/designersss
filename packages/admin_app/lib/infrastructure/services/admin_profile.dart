import 'package:admin_app/domain.dart';
import 'package:admin_app/infrastructure.dart';

final class AdminProfileServiceImpl implements AdminProfileService {
  AdminProfileServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<DataOrFailure<AdminProfile>> getProfile({
    required AccountId accountId,
  }) {
    return _dio
        .get('/profile/$accountId')
        .toData((r) => AdminProfile.fromJson(r));
  }
}
