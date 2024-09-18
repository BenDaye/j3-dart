import 'package:orm/orm.dart';
import 'package:pos/prisma/client.dart';
import 'package:pos/prisma/model.dart';
import 'package:pos/prisma/prisma.dart';
import 'package:pos/server/services/base.dart';

class OrderService
    implements BaseService<Order, OrderCreateInput, OrderUncheckedUpdateInput> {
  @override
  final PrismaClient prismaClient;

  OrderService({required this.prismaClient});

  @override
  Future<Iterable<Order>> getAll() async {
    return await prismaClient.order.findMany();
  }

  @override
  Future<Order?> getById(String id) async {
    return await prismaClient.order
        .findUnique(where: OrderWhereUniqueInput(id: id));
  }

  @override
  Future<bool> create(OrderCreateInput data) async {
    try {
      await prismaClient.order.create(data: PrismaUnion.$1(data));
      return true;
    } catch (err) {
      return false;
    }
  }

  @override
  Future<bool> update(String id, OrderUncheckedUpdateInput data) async {
    try {
      await prismaClient.order.update(
          where: OrderWhereUniqueInput(id: id), data: PrismaUnion.$2(data));

      return true;
    } catch (err) {
      return false;
    }
  }

  @override
  Future<bool> delete(String id) async {
    try {
      await prismaClient.order.delete(where: OrderWhereUniqueInput(id: id));

      return true;
    } catch (err) {
      return false;
    }
  }
}
