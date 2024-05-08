import 'package:admin_backend/infrastructure.dart';
import 'package:postgres/postgres.dart';

Handler middleware(Handler handler) {
  return handler
      .use(adminAuthentication())
      .use(_provideManagers())
      .use(_providePostgres())
      .use(requestLogger());
}

Connection? _connection;

Middleware _providePostgres() {
  return (handler) {
    return (context) async {
      _connection ??= await Connection.open(
        Endpoint(
          host: Environments.dbHost,
          port: Environments.dbPort,
          database: Environments.dbName,
          username: Environments.dbUsername,
          password: Environments.dbPassword,
        ),
        settings: ConnectionSettings(sslMode: SslMode.disable),
      );

      return handler(context.provide(() => _connection!));
    };
  };
}

Middleware _provideManagers() {
  return (handler) {
    return (context) async {
      return handler(
        context
            .provide(() => AdminSessionManager(context.read<Connection>()))
            .provide(() => AdminAccountManager(context.read<Connection>()))
            .provide(() => AdminProfileManager(context.read<Connection>()))
            .provide(() => CollectionLinkManager(context.read<Connection>())),
      );
    };
  };
}
