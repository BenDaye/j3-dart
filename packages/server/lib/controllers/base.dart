import 'package:logging/logging.dart' as logging;
import 'package:server/prisma/client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

abstract class ServerController {
  PrismaClient get prismaClient;
  Router get router;

  logging.Logger get log;

  Future<Response> getAll(Request request);
  Future<Response> getById(Request request, String id);
  Future<Response> create(Request request);
  Future<Response> update(Request request, String id);
  Future<Response> delete(Request request, String id);
}

class BaseController implements ServerController {
  @override
  final PrismaClient prismaClient;

  BaseController({required this.prismaClient});

  @override
  Router get router {
    final router = Router();

    router.get('/', getAll);
    router.get('/<id>', getById);
    router.post('/', create);
    router.put('/<id>', update);
    router.delete('/<id>', delete);

    return router;
  }

  @override
  logging.Logger get log => logging.Logger('Controller');

  @override
  Future<Response> getAll(Request request) async {
    return Response.forbidden('Not Implemented');
  }

  @override
  Future<Response> getById(Request request, String id) async {
    return Response.forbidden('Not Implemented');
  }

  @override
  Future<Response> create(Request request) async {
    return Response.forbidden('Not Implemented');
  }

  @override
  Future<Response> update(Request request, String id) async {
    return Response.forbidden('Not Implemented');
  }

  @override
  Future<Response> delete(Request request, String id) async {
    return Response.forbidden('Not Implemented');
  }
}
