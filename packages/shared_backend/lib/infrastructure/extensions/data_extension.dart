import 'dart:convert';
import 'package:shared_backend/domain.dart';

extension DataExtension<T> on DataOrFailure<T> {
  Response toResponse() {
    return when(
      success: (data) {
        try {
          if (data == null) return Response(statusCode: HttpStatus.ok);

          final json = switch (data) {
            List() => data.map((e) {
                return (e as dynamic).toJson();
              }).toList(),
            _ => ((data as dynamic).toJson()) as Map<String, dynamic>,
          };

          final result = switch (data) {
            List() => {'items': json},
            _ => {'data': json},
          };

          return Response(
            statusCode: HttpStatus.ok,
            body: jsonEncode(result),
          );
        } on NoSuchMethodError catch (e) {
          throw 'Data to response convertation error: ${e}';
        }
      },
      failure: (failure) {
        try {
          failure = failure as BackendFailure;

          return Response(
            statusCode: failure.statusCode,
            body: jsonEncode({'failure': failure.toJson()}),
          );
        } on NoSuchMethodError catch (_) {
          throw 'Failure to response convertation error: Failure is not BackendFailure';
        }
      },
    );
  }
}

extension FutureDataExtension<T> on Future<DataOrFailure<T>> {
  Future<Response> toResponse() async {
    return (await this).toResponse();
  }
}

extension BackendFailureToResponse on BackendFailure {
  Response toResponse() {
    return failed(this).toResponse();
  }
}
