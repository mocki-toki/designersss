import 'package:admin_app/domain.dart';
import 'package:admin_app/presentation.dart';

final class AuthorizationLogic extends Logic {
  AuthorizationLogic(super.context, this.onResult);

  final VoidCallback onResult;

  late final dataNotifier = DataNotifier<AdminSession>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void disposeLogic() {
    dataNotifier.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.disposeLogic();
  }

  Future<void> signIn() {
    final email = emailController.text;
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(context.sharedAppLocalizations.fillAllFieldsError),
        ),
      );
      return SynchronousFuture(null);
    }

    return dataNotifier.loadData(
      getRequired<AdminSessionService>()
          .signIn(email: email, password: password),
      onSuccess: (data) {
        onResult();
      },
      onFailure: (failure) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(failure.toLocalizedString(context)),
          ),
        );
      },
    );
  }
}
