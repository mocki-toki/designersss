import 'package:admin_app/domain.dart';
import 'package:admin_app/infrastructure.dart';
import 'package:admin_app/presentation.dart';

final class UsersLogic extends Logic {
  UsersLogic(super.sp);

  late final dataNotifier = DataNotifier<AdminProfile>();

  @override
  Future<void> initLogic() async {
    super.initLogic();
    final currentAccountId =
        (await getRequired<StorageService>().getSession())!.accountId;

    dataNotifier.loadData(
      getRequired<AdminProfileService>()
          .getProfile(accountId: currentAccountId),
    );
  }

  @override
  void disposeLogic() {
    dataNotifier.dispose();
    super.disposeLogic();
  }

  void signOut() {
    getRequired<AdminSessionService>().signOut();
  }
}
