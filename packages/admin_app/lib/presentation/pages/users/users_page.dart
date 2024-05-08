import 'package:admin_app/presentation.dart';

@RoutePage()
final class UsersPage extends WidgetWithLogic<UsersLogic> {
  const UsersPage({super.key});

  @override
  logicBuilder(context) => UsersLogic(context);

  @override
  Widget build(context, logic) {
    return Scaffold(
      body: logic.dataNotifier.when(
        success: (profile) {
          return const Text('Users Page');
        },
      ),
    );
  }
}
