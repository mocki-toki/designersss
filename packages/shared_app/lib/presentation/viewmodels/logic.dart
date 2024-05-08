import 'dart:async';

import 'package:shared_app/infrastructure.dart';
import 'package:shared_app/presentation.dart';

abstract class Logic {
  const Logic(this.context);

  @protected
  final BuildContext context;

  @protected
  T getRequired<T>() => context.read<ServiceProvider>().getRequired<T>();

  FutureOr<void> initLogic() {}

  void disposeLogic() {}

  @protected
  ScaffoldMessengerState get scaffoldMessenger =>
      getRequired<ScaffoldMessengerProvider>().scaffoldMessenger;
}
