import 'package:shared_admin/domain.dart';

final class AdminAccount {
  AdminAccount({
    required this.id,
    required this.email,
    required this.permissions,
  });

  final UuidValue id;
  final String email;
  final List<AdminAccountPermission> permissions;

  bool hasPermissions(List<AdminAccountPermission> permissions) {
    return permissions.every(this.permissions.contains);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': '$id',
      'email': email,
      'permissions': permissions.map((e) => e.name).toList(),
    };
  }

  static AdminAccount fromJson(Map<String, dynamic> json) {
    return AdminAccount(
      id: UuidValue.fromString(json['id'] as String),
      email: json['email'] as String,
      permissions: (json['permissions'] as List)
          .map((e) => AdminAccountPermission.values.byName(e as String))
          .toList(),
    );
  }
}

enum AdminAccountPermission {
  collection,
  posts,
  users,
  adminAccounts,
}
