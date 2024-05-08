import 'package:main_backend/domain.dart';
import 'package:main_backend/infrastructure.dart';

Handler middleware(Handler handler) {
  return handler.use(
    (handler) => (context) async {
      return handler(
        context.provide<CollectionLinkService>(
          () => CollectionLinkEndpoint(
            context.read<CollectionLinkManager>(),
          ),
        ),
      );
    },
  );
}
