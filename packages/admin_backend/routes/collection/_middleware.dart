import 'package:admin_backend/domain.dart';
import 'package:admin_backend/infrastructure.dart';

Handler middleware(Handler handler) {
  return handler.use(
    (handler) => (context) async {
      return handler(
        context.provide<AdminCollectionLinkService>(
          () => AdminCollectionLinkEndpoint(
            context.read<CollectionLinkManager>(),
          ),
        ),
      );
    },
  );
}
