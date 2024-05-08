import 'dart:async';
import 'dart:io';

import 'package:shared_app/domain.dart';
import 'package:shared_app/infrastructure.dart';
import 'package:flutter/foundation.dart';

const _preferencesKey = 'preferences';

final class StorageService implements Initializable, Disposable {
  StorageService(this._environment);

  final Environment _environment;

  late Directory? _directory;
  late Box _preferencesForAllAccounts;

  @override
  Future<void> initialize() async {
    _directory = kIsWeb ? null : await getApplicationDocumentsDirectory();
    _preferencesForAllAccounts = await Hive.openBox(
      '${_preferencesKey}_$_environment',
      path: _directory?.path,
    );
  }

  @override
  Future<void> dispose() {
    return _preferencesForAllAccounts.close();
  }

  Box get preferencesForAllAccounts => _preferencesForAllAccounts;
}
