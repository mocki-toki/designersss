import 'package:main_app/presentation.dart';

@RoutePage()
final class InterfacesPage extends WidgetWithLogic<InterfacesLogic> {
  const InterfacesPage({super.key});

  @override
  logicBuilder(context) => InterfacesLogic(context);

  @override
  Widget build(context, logic) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      body: Center(
        child: MessageBanner(
          message: context.mainAppLocalizations.inDevelopment,
          iconData: Icons.construction,
        ),
      ),
    );
  }
}
