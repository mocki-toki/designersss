import 'package:main_backend/infrastructure.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;

Handler middleware(Handler handler) {
  return handler
      .use(_provideManagers())
      .use(_providePostgres())
      .use(
        fromShelfMiddleware(
          shelf.corsHeaders(
            headers: {
              shelf.ACCESS_CONTROL_ALLOW_ORIGIN: '*',
              shelf.ACCESS_CONTROL_ALLOW_METHODS:
                  'GET,PUT,POST,PATCH,DELETE,OPTIONS',
              shelf.ACCESS_CONTROL_ALLOW_HEADERS:
                  'Origin, Content-Type, Accept, Authorization',
            },
          ),
        ),
      )
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
            .provide(() => CollectionLinkManager(context.read<Connection>())),
      );
    };
  };
}
