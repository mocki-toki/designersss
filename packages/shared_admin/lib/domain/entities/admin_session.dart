import 'package:shared_admin/domain.dart';

final class AdminSession {
  AdminSession({
    required this.accountId,
    required this.token,
    required this.expires,
  });

  final AccountId accountId;
  final Token token;
  final DateTime expires;

  Map<String, dynamic> toJson() {
    return {
      'account_id': '$accountId',
      'token': '$token',
      'expires': expires.toIso8601String(),
    };
  }

  static AdminSession fromJson(Map<String, dynamic> json) {
    return AdminSession(
      accountId: AccountId.fromString(json['account_id'] as String),
      token: json['token'] as Token,
      expires: DateTime.parse(json['expires'] as String),
    );
  }
}
