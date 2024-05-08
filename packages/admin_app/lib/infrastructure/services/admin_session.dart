import 'dart:async';

import 'package:admin_app/domain.dart';
import 'package:admin_app/infrastructure.dart';
import 'package:admin_app/presentation.dart';

final class AdminSessionServiceImpl
    implements AdminSessionService, Initializable, Disposable {
  AdminSessionServiceImpl(
    this._dio,
    this._adminSessionNotifier,
    this._storageService,
  );

  final Dio _dio;
  final AdminSessionNotifier _adminSessionNotifier;
  final StorageService _storageService;

  Timer? sessionExpirationTimer;

  @override
  Future<void> initialize() async {
    final token = await _storageService.getSession();

    _adminSessionNotifier.value = token != null;
    _checkSessionExpiration(token);
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final session = await _storageService.getSession();
        if (session != null) {
          options.headers['Authorization'] = 'Bearer ${session.token}';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        if (response.statusCode == HttpStatus.unauthorized) signOut();

        if (response.statusCode == HttpStatus.badRequest) {
          final error = response.data?['failure']?['type'] ==
              SessionExpiredFailure().toSnakeCase();

          if (error) signOut();
        }
        return handler.next(response);
      },
    ));
  }

  @override
  Future<void> dispose() async {
    sessionExpirationTimer?.cancel();
  }

  @override
  Future<DataOrFailure<AdminSession>> signIn({
    required String email,
    required String password,
  }) async {
    return await _dio.post('/sign-in', data: {
      'email': email,
      'password': password,
    }).toData((r) => AdminSession.fromJson(r))
      ..onSuccess((data) {
        _adminSessionNotifier.value = true;
        _checkSessionExpiration(data);
        _storageService.saveSession(data);
      });
  }

  @override
  Future<SuccessOrFailure> signOut() async {
    _adminSessionNotifier.value = false;
    sessionExpirationTimer?.cancel();

    final session = await _storageService.getSession();
    if (session == null) return failed(NotSignedInFailure());

    unawaited(_storageService.removeSession());
    return _dio
        .post(
          '/sign-out',
          options: Options(headers: {
            'Authorization': 'Bearer ${session.token}',
          }),
        )
        .toSuccess();
  }

  void _checkSessionExpiration(AdminSession? session) {
    if (session == null) return;

    sessionExpirationTimer = Timer(
      session.expires.difference(DateTime.now().add(Duration(seconds: 5))),
      signOut,
    );
  }
}
