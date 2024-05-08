import 'package:admin_app/presentation.dart';

@RoutePage()
final class PostsPage extends WidgetWithLogic<PostsLogic> {
  const PostsPage({super.key});

  @override
  logicBuilder(context) => PostsLogic(context);

  @override
  Widget build(context, logic) {
    return Scaffold(
      body: logic.dataNotifier.when(
        success: (profile) {
          return const Text('Posts Page');
        },
      ),
    );
  }
}
