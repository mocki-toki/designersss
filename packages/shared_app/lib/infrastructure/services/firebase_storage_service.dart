import 'dart:async';

import 'package:shared_app/infrastructure.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

final class FirebaseStorageService implements Initializable {
  FirebaseStorageService(this._app);

  final FirebaseApp? _app;

  late final FirebaseStorage _storage;

  @override
  Future<void> initialize() async {
    _storage = await FirebaseStorage.instanceFor(app: _app);
  }

  FirebaseStorage get storage => _storage;
}
