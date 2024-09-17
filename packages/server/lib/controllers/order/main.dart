import 'package:luthor/luthor.dart';
import 'package:server/controllers/base.dart';
import 'package:server/prisma/prisma.dart';
import 'package:server/services/order/main.dart';
import 'package:server/utils/output.dart';
import 'package:server/utils/validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class OrderController extends BaseController implements ServerController {
  OrderController({required super.prismaClient})
      : service = OrderService(prismaClient: prismaClient);

  final OrderService service;

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
  Future<Response> getAll(Request request) async {
    try {
      final result = await service.getAll();
      log.info(result);
      return outputSuccess(data: result.map((e) => e.toJson()).toList());
    } catch (err) {
      log.severe(err);
      return outputError(data: err.toString());
    }
  }

  @override
  Future<Response> getById(Request request, String id) async {
    final validateIdResult = await validateId<String>(id: id);
    if (!validateIdResult.isValid) {
      return outputValidateError(data: validateIdResult.errors);
    }

    try {
      final result = await service.getById(validateIdResult.data);
      if (result == null) {
        return outputNotFoundError();
      }
      return outputSuccess(data: result.toJson());
    } catch (err) {
      return outputError(data: err.toString());
    }
  }

  @override
  Future<Response> create(Request request) async {
    final schema = l.schema({
      'title': l.string().required(),
    });
    final validateSchemaResult = await validateSchema<OrderCreateInput>(
      request: request,
      schema: schema,
    );
    if (!validateSchemaResult.isValid) {
      return outputValidateError(data: validateSchemaResult.errors);
    }

    try {
      await service.create(validateSchemaResult.data);
      return outputSuccess();
    } catch (err) {
      return outputError(data: err.toString());
    }
  }

  @override
  Future<Response> update(Request request, String id) async {
    final validateIdResult = await validateId<String>(id: id);
    if (!validateIdResult.isValid) {
      return outputValidateError(data: validateIdResult.errors);
    }

    final schema = l.schema({
      'title': l.string().required(),
    });
    final validateSchemaResult =
        await validateSchema<OrderUncheckedUpdateInput>(
      request: request,
      schema: schema,
    );
    if (!validateSchemaResult.isValid) {
      return outputValidateError(data: validateSchemaResult.errors);
    }

    try {
      await service.update(validateIdResult.data, validateSchemaResult.data);
      return outputSuccess();
    } catch (err) {
      return outputError(data: err.toString());
    }
  }

  @override
  Future<Response> delete(Request request, String id) async {
    final validateIdResult = await validateId<String>(id: id);
    if (!validateIdResult.isValid) {
      return outputValidateError(data: validateIdResult.errors);
    }

    try {
      await service.delete(validateIdResult.data);
      return outputSuccess();
    } catch (err) {
      return outputError(data: err.toString());
    }
  }
}
