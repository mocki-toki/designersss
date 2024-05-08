import 'dart:async';

import 'package:shared_app/domain.dart';
import 'package:shared_app/infrastructure.dart';

const _baseUrls = {
  Environment.development: 'localhost',
  Environment.production: 'localhost',
};
const _port = 8080;

final class BackendClientService implements Initializable, Disposable {
  BackendClientService(this._environment);

  final Environment _environment;

  late final _client = Dio(
    BaseOptions(baseUrl: 'http://${_baseUrls[_environment]}:$_port'),
  );

  @override
  Future<void> initialize() async {
    return _client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          Logger.root.info('Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          Logger.root.info('Response: ${response.statusCode}');
          return handler.next(response);
        },
      ),
    );
  }

  @override
  Future<void> dispose() async {
    return _client.close();
  }

  Dio get client => _client;
}
