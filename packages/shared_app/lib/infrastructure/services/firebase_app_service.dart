import 'dart:async';

import 'package:shared_app/infrastructure.dart';
import 'package:firebase_core/firebase_core.dart';

final class FirebaseAppService implements Initializable, Disposable {
  FirebaseAppService(this._options);

  final FirebaseOptions? _options;

  late final FirebaseApp _app;

  @override
  Future<void> initialize() async {
    _app = await Firebase.initializeApp(options: _options);
  }

  @override
  Future<void> dispose() {
    return _app.delete();
  }

  FirebaseApp get app => _app;
}
