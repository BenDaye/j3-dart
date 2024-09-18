import 'dart:convert';

import 'package:pos/server/controllers/base.dart';
import 'package:shelf/shelf.dart';

class OutputResponse {
  final int code;
  final String message;
  final dynamic data;

  OutputResponse({
    required this.code,
    required this.message,
    this.data,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'data': data,
      };

  String toJsonString() => jsonEncode(toJson());
}

extension Output on BaseController {
  Response outputResponse({
    required OutputResponse response,
    Map<String, String>? headers = const {
      'Content-Type': 'application/json',
    },
  }) {
    return Response.ok(
      response.toJsonString(),
      headers: headers,
    );
  }

  Response outputError({
    int code = 500,
    String message = 'Internal Server Error',
    dynamic data,
    Map<String, String>? headers = const {
      'Content-Type': 'application/json',
    },
  }) {
    return Response.ok(
      OutputResponse(
        code: code,
        message: message,
        data: data,
      ).toJsonString(),
      headers: headers,
    );
  }

  Response outputValidateError({
    int code = 400,
    String message = 'Bad Request',
    dynamic data,
    Map<String, String>? headers = const {
      'Content-Type': 'application/json',
    },
  }) {
    return Response.ok(
      OutputResponse(
        code: code,
        message: message,
        data: data,
      ).toJsonString(),
      headers: headers,
    );
  }

  Response outputNotFoundError({
    int code = 404,
    String message = 'Not Found',
    dynamic data,
    Map<String, String>? headers = const {
      'Content-Type': 'application/json',
    },
  }) {
    return Response.ok(
      OutputResponse(
        code: code,
        message: message,
        data: data,
      ).toJsonString(),
      headers: headers,
    );
  }

  Response outputSuccess({
    int code = 200,
    String message = 'Success',
    dynamic data,
    Map<String, String>? headers = const {
      'Content-Type': 'application/json',
    },
  }) {
    return Response.ok(
      OutputResponse(
        code: code,
        message: message,
        data: data,
      ).toJsonString(),
      headers: headers,
    );
  }
}
