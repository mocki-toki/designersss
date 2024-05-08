import 'dart:convert';
import 'dart:io';

import 'package:admin_app/domain.dart';
import 'package:admin_app/infrastructure.dart';

// TODO: refactor this
extension AdminDataExtension on Future<Response> {
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
        DioException() => AdminBackendFailureHandler.toFailure(e),
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

final class AdminBackendFailureHandler {
  static Failure toFailure(DioException e) {
    if (e.response?.data != null) {
      try {
        final failure = AdminBackendFailure.fromJson(
          (jsonDecode(e.response!.data) as Map<String, dynamic>)['failure']!,
        );

        Logger.root.warning('Failure: $failure');
        return failure;
      } catch (_) {
        return SharedBackendFailureHandler.toFailure(e);
      }
    }

    return SharedBackendFailureHandler.toFailure(e);
  }
}
