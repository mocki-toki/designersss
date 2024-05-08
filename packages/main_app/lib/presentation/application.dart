import 'package:main_app/infrastructure.dart';
import 'package:main_app/presentation.dart';

final class Application extends StatelessWidget {
  const Application(this.dependencies, {super.key});

  final ServiceProvider dependencies;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: dependencies),
      ],
      child: MaterialApp.router(
        localizationsDelegates: {
          ...SharedAppLocalizations.localizationsDelegates,
          ...MainAppLocalizations.localizationsDelegates,
        }.toList(),
        supportedLocales: {
          ...SharedAppLocalizations.supportedLocales,
          ...MainAppLocalizations.supportedLocales,
        }.toList(),
        scaffoldMessengerKey: dependencies
            .getRequired<ScaffoldMessengerProvider>()
            .scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        routerConfig: dependencies.getRequired<AppRouter>().config(),
        title: 'Design HUB',
        scrollBehavior: _ScrollBehavior(),
        locale: Locale('ru'),
      ),
    );
  }
}

final class _ScrollBehavior extends ScrollBehavior {
  const _ScrollBehavior();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}
