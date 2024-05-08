import 'package:admin_app/domain.dart';
import 'package:admin_app/presentation.dart';

@RoutePage()
final class RootPage extends WidgetWithLogic<RootLogic> {
  const RootPage({super.key});

  @override
  logicBuilder(context) => RootLogic(context);

  @override
  Widget build(context, logic) {
    return Scaffold(
      body: [logic.adminAccountDataNotifier, logic.profileDataNotifier].when(
        success: (dataList) {
          final account = dataList.get<AdminAccount>();
          final profile = dataList.get<AdminProfile>();
          final tabs = _getTabs(account);

          return AutoTabsRouter(
            routes: tabs.map((e) => e.route).toList(),
            builder: (context, child) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        ...[
                          for (int i = 0; i < tabs.length; i++)
                            _TabWidget(tabs, i),
                        ].separated(const SizedBox(width: 5)),
                        const Spacer(),
                        Text(
                          context.adminAppLocalizations
                              .welcomeMessage(profile.name),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: logic.signOut,
                          child: Text(context.sharedAppLocalizations.signOut),
                        ),
                      ],
                    ),
                  ),
                  ColoredBox(
                    color: Colors.black12,
                    child: SizedBox(height: 1, width: double.infinity),
                  ),
                  Expanded(child: child),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

final class _TabWidget extends StatelessWidget {
  final List<_TabModel> tabs;
  final int index;

  const _TabWidget(this.tabs, this.index);

  @override
  Widget build(context) {
    final tabsRouter = AutoTabsRouter.of(context);
    final tab = tabs[index];

    if (tabsRouter.activeIndex == index) {
      return FilledButton.icon(
        label: Text(tab.title),
        icon: Icon(tab.icon),
        onPressed: () => tabsRouter.setActiveIndex(index),
      );
    } else {
      return ElevatedButton.icon(
        label: Text(tab.title),
        icon: Icon(tab.icon),
        onPressed: () => tabsRouter.setActiveIndex(index),
      );
    }
  }
}

List<_TabModel> _getTabs(AdminAccount account) => [
      if (account.hasPermissions([AdminAccountPermission.collection]))
        _TabModel(
          title: 'Collection',
          icon: Icons.dashboard_rounded,
          route: CollectionRoute(),
        ),
      if (account.hasPermissions([AdminAccountPermission.posts]))
        _TabModel(
          title: 'Posts',
          icon: Icons.list_alt_rounded,
          route: PostsRoute(),
        ),
      if (account.hasPermissions([AdminAccountPermission.users]))
        _TabModel(
          title: 'Users',
          icon: Icons.account_box_outlined,
          route: UsersRoute(),
        ),
    ];

final class _TabModel {
  final String title;
  final IconData icon;
  final PageRouteInfo route;

  const _TabModel({
    required this.title,
    required this.icon,
    required this.route,
  });
}
