import 'dart:convert';

import 'package:admin_backend/domain.dart';
import 'package:admin_backend/infrastructure.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/sign-up/index.dart' as route;

final class _MockRequestContext extends Mock implements RequestContext {}

final class _AdminAccountManager extends Mock implements AdminAccountManager {}

final class _AdminSessionManager extends Mock implements AdminSessionManager {}

void main() {
  group('POST /sign-up', () {
    final uri = Uri.parse('http://localhost/sign-up');

    final context = _MockRequestContext();
    final accountManager = _AdminAccountManager();
    final sessionManager = _AdminSessionManager();

    final accountId = Uuid().v4obj();
    final email = 'test_email';
    final password = 'test_password';
    final permissions = [AdminAccountPermission.adminAccounts];
    final token = 'test_token';

    final account = AdminAccount(
      id: accountId,
      email: email,
      permissions: permissions,
    );

    when(() => accountManager.create(
        email: email,
        password: password,
        permissions: permissions)).thenAnswer((_) => Future.value(account));

    when(() => accountManager.getByEmailOrNull(email))
        .thenAnswer((_) => Future.value(null));

    test('Sign up without token', () async {
      // Arrange
      when(() => context.read<AdminSessionService>()).thenReturn(
        AdminSessionEndpoint(
          null,
          sessionManager,
          accountManager,
        ),
      );

      when(() => context.request).thenReturn(
        Request(
          'POST',
          Uri.parse('http://localhost/sign-up'),
          body: jsonEncode({
            'email': email,
            'password': password,
            'permissions': permissions.map((e) => e.name).toList(),
          }),
        ),
      );

      // Act
      final response = await route.onRequest(context);

      // Assert
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.body(),
        completion(
          equals(
            jsonEncode({
              "data": {
                "id": "$accountId",
                "email": email,
                "permissions": permissions.map((e) => e.name).toList(),
              }
            }),
          ),
        ),
      );
    });

    test('Sign up with token', () async {
      // Arrange
      when(() => context.read<AdminSessionService>()).thenReturn(
        AdminSessionEndpoint(
          AdminAccount(
            id: accountId,
            email: email,
            permissions: permissions,
          ),
          sessionManager,
          accountManager,
        ),
      );

      when(() => context.request).thenReturn(
        Request(
          'POST',
          uri,
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'email': email,
            'password': password,
            'permissions': permissions.map((e) => e.name).toList(),
          }),
        ),
      );

      // Act
      final response = await route.onRequest(context);

      // Assert
      expect(response.statusCode, equals(HttpStatus.conflict));
      expect(
        response.body(),
        completion(
          equals(
            jsonEncode({
              "failure": {"type": "already_signed_in_failure"}
            }),
          ),
        ),
      );
    });
  });
}
