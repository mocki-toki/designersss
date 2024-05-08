import 'package:shared_app/presentation.dart';

final class ScaffoldMessengerProvider {
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  ScaffoldMessengerState get scaffoldMessenger =>
      scaffoldMessengerKey.currentState!;
}
