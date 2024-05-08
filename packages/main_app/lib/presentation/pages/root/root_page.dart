import 'package:main_app/presentation.dart';

@RoutePage()
final class RootPage extends WidgetWithLogic<RootLogic> {
  const RootPage({super.key});

  @override
  logicBuilder(context) => RootLogic(context);

  @override
  Widget build(context, logic) {
    final _tabs = [
      _TabModel(
        title: context.mainAppLocalizations.collectionTitle,
        route: CollectionRoute(),
      ),
      _TabModel(
        title: context.mainAppLocalizations.interfacesTitle,
        route: InterfacesRoute(),
      ),
      _TabModel(
        title: context.mainAppLocalizations.bookmarksTitle,
        route: InterfacesRoute(),
      ),
      _TabModel(
        title: context.mainAppLocalizations.settingsTitle,
        route: InterfacesRoute(),
      ),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      body: AutoTabsRouter(
        routes: _tabs.map((tab) => tab.route).toList(),
        builder: (context, child) {
          return Row(
            children: [
              Container(
                width: 308,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Color(0x33000000),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 60,
                    bottom: 22,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Clickable(
                        onTap: () => CollectionRoute().push(context),
                        child: Image.asset(
                          'assets/images/logo.png',
                          package: 'shared_app',
                          height: 52,
                          width: 217,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ...[
                        _TabWidget(_tabs, 0),
                        _TabWidget(_tabs, 1),
                        const Spacer(),
                        _TabWidget(_tabs, 2),
                        _TabWidget(_tabs, 3),
                      ].separated(const SizedBox(height: 9)),
                    ],
                  ),
                ),
              ),
              Expanded(child: child),
            ],
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
    final tab = tabs[index];

    final tabsRouter = AutoTabsRouter.of(context);
    final isActived = tabsRouter.activeIndex == index;

    return Clickable(
      onTap: () => tabsRouter.setActiveIndex(index),
      child: Row(
        children: [
          Text(
            tab.title,
            style: TextStyle(
              fontFamily: 'Cygre',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              height: 32.34 / 20,
              color: isActived ? Colors.black : Color(0xFF9A9A9A),
            ),
          ),
        ],
      ),
    );
  }
}

final class _TabModel {
  final String title;
  final PageRouteInfo route;

  const _TabModel({
    required this.title,
    required this.route,
  });
}
