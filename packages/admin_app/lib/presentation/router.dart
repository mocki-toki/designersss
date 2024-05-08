import 'package:admin_app/presentation.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter implements AutoRouteGuard {
  AppRouter(this._adminSessionNotifier);

  final AdminSessionNotifier _adminSessionNotifier;

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
            page: PostsRoute.page,
            path: 'posts',
          ),
          CustomRoute(
            page: UsersRoute.page,
            path: 'users',
          ),
        ],
      ),
      CustomRoute(
        page: AuthorizationRoute.page,
        path: '/login',
      ),
    ];
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_adminSessionNotifier.value ||
        resolver.routeName == AuthorizationRoute.name) {
      resolver.next(true);
    } else {
      resolver.redirect(
        AuthorizationRoute(onResult: () => resolver.next(true)),
      );
    }
  }
}
