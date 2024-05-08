import 'dart:async';
import 'dart:convert';

import 'package:shared_backend/domain.dart';
import 'package:shared_backend/infrastructure.dart';

extension ResponseExtension on RequestContext {
  Future<Response> getRequiredParametersFromBody(
    List<String> parameters,
    List<Type> paramenterTypes,
    Future<Response> Function(Map<String, dynamic>) callback,
  ) async {
    try {
      var body = await request.body();
      if (body.isEmpty) body = '{}';

      final json = jsonDecode(body) as Map<String, dynamic>;

      final missingParameters = parameters.where((p) => !json.containsKey(p));
      final unknownParameters = json.keys.where((p) => !parameters.contains(p));
      final invalidParameters = <String, Type>{};

      if (missingParameters.isNotEmpty) {
        return Future.value(
          MissingParametersFailure(missingParameters).toResponse(),
        );
      } else if (unknownParameters.isNotEmpty) {
        return Future.value(
          UnknownParametersFailure(unknownParameters).toResponse(),
        );
      } else {
        for (var i = 0; i < parameters.length; i++) {
          if (json[parameters[i]].runtimeType != paramenterTypes[i]) {
            invalidParameters[parameters[i]] = paramenterTypes[i];
          }
        }

        if (invalidParameters.isNotEmpty) {
          return Future.value(
            InvalidParameterTypesFailure(
              invalidParameters.keys,
              invalidParameters.values.map((e) => e.toString()),
            ).toResponse(),
          );
        }

        return callback(json);
      }
    } on FormatException catch (e) {
      return Future.value(
        InvalidBodyFormatFailure(e.toString().split(')').first + ")")
            .toResponse(),
      );
    }
  }

  T? readOrNull<T>() {
    try {
      return read<T>();
    } catch (_) {
      return null;
    }
  }
}
