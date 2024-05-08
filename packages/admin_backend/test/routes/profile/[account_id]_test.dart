import 'dart:convert';

import 'package:admin_backend/domain.dart';
import 'package:admin_backend/infrastructure.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/profile/[account_id].dart' as route;

final class _MockRequestContext extends Mock implements RequestContext {}

final class _AdminAccountManager extends Mock implements AdminAccountManager {}

class _AdminProfileManager extends Mock implements AdminProfileManager {}

void main() {
  group('GET /profile/[account_id]', () {
    final accountId = Uuid().v4obj();

    final method = 'GET';
    final uri = Uri.parse('http://localhost/profile/$accountId');

    final context = _MockRequestContext();
    final accountManager = _AdminAccountManager();
    final profileManager = _AdminProfileManager();

    final name = 'test_name';

    test('Get existing profile', () async {
      // Arrange

      when(() => context.read<AdminAccount>()).thenReturn(AdminAccount(
        id: Uuid().v4obj(),
        email: 'test_email',
        permissions: [],
      ));

      when(() => context.read<AdminProfileService>()).thenReturn(
        AdminProfileEndpoint(
          accountManager,
          profileManager,
        ),
      );

      when(() => accountManager.getByIdOrNull(accountId)).thenAnswer(
        (_) async => AdminAccount(
          id: accountId,
          email: 'test_email',
          permissions: [],
        ),
      );

      when(() => profileManager.getByAccountIdOrCreate(accountId)).thenAnswer(
        (_) async => AdminProfile(
          accountId: accountId,
          name: name,
        ),
      );

      when(() => context.request).thenReturn(
        Request(
          method,
          uri,
        ),
      );

      // Act
      final response = await route.onRequest(context, '$accountId');

      // Assert
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.body(),
        completion(
          equals(
            jsonEncode({
              "data": {
                "account_id": "$accountId",
                "name": name,
              }
            }),
          ),
        ),
      );
    });

    test('Get non existing profile', () async {
      // Arrange

      when(() => context.readOrNull<AdminAccount>()).thenReturn(AdminAccount(
        id: Uuid().v4obj(),
        email: 'test_email',
        permissions: [],
      ));

      when(() => context.read<AdminProfileService>()).thenReturn(
        AdminProfileEndpoint(
          accountManager,
          profileManager,
        ),
      );

      when(() => accountManager.getByIdOrNull(accountId))
          .thenAnswer((_) async => null);

      when(() => profileManager.getByAccountIdOrCreate(accountId)).thenAnswer(
        (_) async => AdminProfile(
          accountId: accountId,
          name: name,
        ),
      );

      when(() => context.request).thenReturn(
        Request(
          method,
          uri,
        ),
      );

      // Act
      final response = await route.onRequest(context, '$accountId');

      // Assert
      expect(response.statusCode, equals(HttpStatus.notFound));
      expect(
        response.body(),
        completion(
          equals(
            jsonEncode({
              "failure": {"type": "account_not_found_failure"}
            }),
          ),
        ),
      );
    });

    test('Get without authentication', () async {
      // Arrange

      when(() => context.readOrNull<AdminAccount>()).thenReturn(null);

      when(() => context.read<AdminProfileService>()).thenReturn(
        AdminProfileEndpoint(
          accountManager,
          profileManager,
        ),
      );

      when(() => accountManager.getByIdOrNull(accountId))
          .thenAnswer((_) async => null);

      when(() => profileManager.getByAccountIdOrCreate(accountId)).thenAnswer(
        (_) async => AdminProfile(
          accountId: accountId,
          name: name,
        ),
      );

      when(() => context.request).thenReturn(
        Request(
          method,
          uri,
        ),
      );

      // Act
      final response = await route.onRequest(context, '$accountId');

      // Assert
      expect(response.statusCode, equals(HttpStatus.unauthorized));
      expect(
        response.body(),
        completion(
          equals(
            jsonEncode({
              "failure": {"type": "not_signed_in_failure"}
            }),
          ),
        ),
      );
    });
  });
}
