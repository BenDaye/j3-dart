import 'dart:convert';

import 'package:luthor/luthor.dart';
import 'package:server/controllers/base.dart';
import 'package:shelf/shelf.dart';

class ValidateSchemaResult<T> {
  final T? _data;
  final Map<String, List<String>> _errors;
  final bool isValid;

  ValidateSchemaResult({
    T? data,
    Map<String, List<String>> errors = const {},
    required this.isValid,
  })  : _data = data,
        _errors = errors;

  T get data {
    if (isValid) {
      return _data as T;
    } else {
      throw StateError('数据无效时无法访问');
    }
  }

  T? get dataOrNull => _data;

  Map<String, List<String>> get errors {
    if (isValid) {
      return {};
    } else {
      return _errors;
    }
  }
}

class ValidateValueResult<T> {
  final T? _data;
  final List<String> _errors;
  final bool isValid;

  ValidateValueResult({
    T? data,
    List<String> errors = const [],
    required this.isValid,
  })  : _data = data,
        _errors = errors;

  T get data {
    if (isValid) {
      return _data as T;
    } else {
      throw StateError('数据无效时无法访问');
    }
  }

  T? get dataOrNull => _data;

  List<String> get errors {
    if (isValid) {
      return [];
    } else {
      return _errors;
    }
  }
}

extension Validation on BaseController {
  Future<ValidateSchemaResult<T>> validateSchema<T>({
    required Request request,
    required Validator schema,
  }) async {
    final input = jsonDecode(await request.readAsString());
    final validation = schema.validateSchema<T>(input);

    switch (validation) {
      case SchemaValidationSuccess(data: final T data):
        {
          return ValidateSchemaResult(data: data, isValid: true);
        }
      case SchemaValidationError(
          data: final T? data,
          errors: final Map<String, List<String>> errors
        ):
        {
          log.severe(errors);
          return ValidateSchemaResult(
              data: data, errors: errors, isValid: false);
        }
      default:
        {
          return ValidateSchemaResult(data: null, errors: {}, isValid: false);
        }
    }
  }

  Future<ValidateValueResult<T>> validateId<T>({
    required dynamic id,
    Validator? schema,
  }) async {
    schema ??= l.string().uuid().required();

    final validation = schema.validateValue<T>(id);

    switch (validation) {
      case SingleValidationSuccess(data: final T data):
        {
          return ValidateValueResult(data: data, isValid: true);
        }
      case SingleValidationError(
          data: final T? data,
          errors: final List<String> errors
        ):
        {
          log.severe(errors);
          return ValidateValueResult(
              data: data, errors: errors, isValid: false);
        }
      default:
        {
          return ValidateValueResult(data: null, errors: [], isValid: false);
        }
    }
  }
}
