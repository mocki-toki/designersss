import 'package:admin_app/presentation.dart';

@RoutePage()
final class AuthorizationPage extends WidgetWithLogic<AuthorizationLogic> {
  const AuthorizationPage({super.key, required this.onResult});

  final VoidCallback onResult;

  @override
  logicBuilder(context) => AuthorizationLogic(context, onResult);

  @override
  Widget build(context, logic) {
    return Scaffold(
      body: logic.dataNotifier.builder(
        builder: (context, state, _) {
          return LoadingDecorator(
            isLoading: state.isLoading,
            child: Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: logic.emailController,
                      decoration: InputDecoration(
                        hintText: context.sharedAppLocalizations.email,
                      ),
                    ),
                    TextField(
                      controller: logic.passwordController,
                      decoration: InputDecoration(
                        hintText: context.sharedAppLocalizations.password,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: logic.signIn,
                      child: Text(context.sharedAppLocalizations.signIn),
                    ),
                  ].separated(const SizedBox(height: 10)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
