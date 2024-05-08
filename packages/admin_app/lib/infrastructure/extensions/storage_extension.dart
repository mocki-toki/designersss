import 'package:admin_app/domain.dart';
import 'package:admin_app/infrastructure.dart';

const _adminSessionKey = 'admin_session';

extension StorageExtension on StorageService {
  Future<void> saveSession(AdminSession session) {
    return preferencesForAllAccounts.put(_adminSessionKey, session.toJson());
  }

  Future<AdminSession?> getSession() async {
    final sessionJson = await preferencesForAllAccounts.get(_adminSessionKey);
    return sessionJson == null
        ? null
        : AdminSession.fromJson(sessionJson.cast<String, dynamic>());
  }

  Future<void> removeSession() {
    return preferencesForAllAccounts.delete(_adminSessionKey);
  }
}
