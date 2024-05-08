import 'package:admin_app/domain.dart';
import 'package:admin_app/infrastructure.dart';
import 'package:admin_app/presentation.dart';

final class RootLogic extends Logic {
  RootLogic(super.sp);

  final adminAccountDataNotifier = DataNotifier<AdminAccount>();
  final profileDataNotifier = DataNotifier<AdminProfile>();

  @override
  Future<void> initLogic() async {
    super.initLogic();
    final currentAccountId =
        (await getRequired<StorageService>().getSession())!.accountId;

    adminAccountDataNotifier.loadData(
      getRequired<AdminAccountManagementService>()
          .getAccount(id: currentAccountId),
    );

    profileDataNotifier.loadData(
      getRequired<AdminProfileService>()
          .getProfile(accountId: currentAccountId),
    );
  }

  @override
  void disposeLogic() {
    adminAccountDataNotifier.dispose();
    profileDataNotifier.dispose();
    super.disposeLogic();
  }

  void signOut() {
    getRequired<AdminSessionService>().signOut();
  }
}
