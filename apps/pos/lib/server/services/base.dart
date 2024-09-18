import 'package:pos/prisma/client.dart';

abstract class BaseService<Base, CreateInput, UpdateInput> {
  abstract final PrismaClient prismaClient;

  Future<Iterable<Base>> getAll();
  Future<Base?> getById(String id);
  Future<bool> create(CreateInput data);
  Future<bool> update(String id, UpdateInput data);
  Future<bool> delete(String id);
}
