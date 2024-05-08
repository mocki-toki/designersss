import 'package:main_app/presentation.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes {
    return [
      CustomRoute(
        page: RootRoute.page,
        initial: true,
        path: '/',
        children: [
          RedirectRoute(path: '', redirectTo: 'collection'),
          CustomRoute(
            page: CollectionRoute.page,
            path: 'collection',
          ),
          CustomRoute(
            page: InterfacesRoute.page,
            path: 'interfaces',
          ),
        ],
      ),
    ];
  }
}
