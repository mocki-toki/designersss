import 'package:shared_admin/domain.dart';

abstract interface class AdminSessionService {
  Future<DataOrFailure<AdminSession>> signIn({
    required String email,
    required String password,
  });

  Future<SuccessOrFailure> signOut();
}
