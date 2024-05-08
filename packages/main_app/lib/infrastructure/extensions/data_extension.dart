import 'dart:convert';
import 'dart:io';

import 'package:shared_app/infrastructure.dart';
import 'package:main_app/domain.dart';

// TODO: refactor this
extension MainDataExtension on Future<Response> {
  Future<DataOrFailure<T>> toData<T>(
    T Function(dynamic response) map, [
    dynamic Function(dynamic response)? from,
  ]) async {
    try {
      final response = await this;
      final result = map.call(
        from != null
            ? from(jsonDecode(response.data))
            : jsonDecode(response.data)['data'] ?? {},
      );

      return successful(result);
    } catch (e) {
      final failure = switch (e) {
        DioException() => SharedBackendFailureHandler.toFailure(e),
        SocketException() => () {
            Logger.root.warning('Network failure');
            return NetworkFailure();
          }(),
        _ => () {
            Logger.root.severe('DOMAIN FAILURE: $e');
            return DomainFailure();
          }(),
      };

      return failed(failure);
    }
  }
}
