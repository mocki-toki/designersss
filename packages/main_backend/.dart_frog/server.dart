// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/index.dart' as index;
import '../routes/collection/dates.dart' as collection_dates;
import '../routes/collection/links/[date].dart' as collection_links_$date;

import '../routes/_middleware.dart' as middleware;
import '../routes/collection/_middleware.dart' as collection_middleware;

void main() async {
  final address = InternetAddress.tryParse('') ?? InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  hotReload(() => createServer(address, port));
}

Future<HttpServer> createServer(InternetAddress address, int port) {
  final handler = Cascade().add(buildRootHandler()).handler;
  return serve(handler, address, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/collection/links', (context) => buildCollectionLinksHandler()(context))
    ..mount('/collection', (context) => buildCollectionHandler()(context))
    ..mount('/', (context) => buildHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildCollectionLinksHandler() {
  final pipeline = const Pipeline().addMiddleware(collection_middleware.middleware);
  final router = Router()
    ..all('/<date>', (context,date,) => collection_links_$date.onRequest(context,date,));
  return pipeline.addHandler(router);
}

Handler buildCollectionHandler() {
  final pipeline = const Pipeline().addMiddleware(collection_middleware.middleware);
  final router = Router()
    ..all('/dates', (context) => collection_dates.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => index.onRequest(context,));
  return pipeline.addHandler(router);
}

