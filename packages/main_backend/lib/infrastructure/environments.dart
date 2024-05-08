import 'dart:io';

final class Environments {
  static String dbHost = Platform.environment['DB_HOST'] ?? 'localhost';
  static int dbPort =
      int.tryParse(Platform.environment['DB_PORT'] ?? '') ?? 5432;
  static String dbName = Platform.environment['DB_NAME'] ?? 'postgres';
  static String dbUsername = Platform.environment['DB_USERNAME'] ?? 'postgres';
  static String dbPassword =
      Platform.environment['DB_PASSWORD'] ?? 'testpassword';
}
