import 'package:main_app/domain.dart';
import 'package:main_app/infrastructure.dart';
import 'package:main_app/presentation.dart';

const _environment = Environment.development;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  _initializeLogger();
  final rootScope = await _initializeDependencies();

  runApp(Application(rootScope.serviceProvider));
}

void _initializeLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    switch (record.level) {
      case Level.SEVERE:
        debugPrint(
          '\x1B[31m${record.level.name}: ${record.time}: ${record.message}\x1B[0m',
        );
      case Level.WARNING:
        debugPrint(
          '\x1B[33m${record.level.name}: ${record.time}: ${record.message}\x1B[0m',
        );
      case Level.INFO:
        debugPrint(
          '\x1B[30m${record.level.name}: ${record.time}: ${record.message}\x1B[0m',
        );
      default:
        debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    }
  });
}

Future<ServiceScope> _initializeDependencies() async {
  final services = ServiceCollection();

  services.addServices();
  services.addPresentation();

  final rootScope = services.buildRootScope();
  await rootScope.initialize();

  return rootScope;
}

extension _Dependencies on ServiceCollection {
  void addServices() {
    addInstance(StorageService(_environment));
    addAlias<Initializable, StorageService>();
    addAlias<Disposable, StorageService>();

    addInstance(BackendClientService(_environment));
    addAlias<Initializable, BackendClientService>();
    addAlias<Disposable, BackendClientService>();
    addSingletonFactory(
      (sp) => sp.getRequired<BackendClientService>().client,
    );
    addSingletonFactory<CollectionLinkService>(
      (sp) => CollectionLinkServiceImpl(sp.getRequired<Dio>()),
    );
  }

  void addPresentation() {
    addInstance(ScaffoldMessengerProvider());
    addInstance(AppRouter());
  }
}
