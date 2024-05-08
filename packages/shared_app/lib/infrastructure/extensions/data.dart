import 'dart:convert';
import 'dart:io';

import 'package:shared_app/domain.dart';
import 'package:shared_app/infrastructure.dart';

extension SharedDataExtension on Future<Response> {
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

extension DataExtension on Future<Response> {
  Future<ListDataOrFailure<T>> toListData<T>(
    T Function(dynamic response) map,
  ) {
    return toData<List<T>>(
      (response) => (response as List).map(map).toList(),
      (response) => response['items'],
    );
  }

  Future<SuccessOrFailure> toSuccess() async {
    return toData<void>((r) => null);
  }
}

final class SharedBackendFailureHandler {
  static Failure toFailure(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) return TimeoutFailure();

    if (e.response?.data != null) {
      try {
        final failure = BackendFailure.fromJson(
          (jsonDecode(e.response!.data) as Map<String, dynamic>)['failure']!,
        );

        Logger.root.warning('Failure: $failure');
        return failure;
      } catch (_) {
        return BackendFailure(e.response!.statusCode!);
      }
    } else if (e.response?.statusCode != null) {
      return BackendFailure(e.response!.statusCode!);
    } else {
      return NetworkFailure();
    }
  }
}
