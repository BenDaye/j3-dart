library server;

import 'dart:io';

import 'package:server/controllers/order/main.dart';
import 'package:server/prisma/client.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

export 'prisma/client.dart';
export 'prisma/model.dart';
export 'prisma/prisma.dart';

export 'server.dart';

class Server {
  late HttpServer server;
  late PrismaClient prismaClient;

  final String? prismaClientDatasourceUrl;
  final int port;
  final String host;

  Server({
    this.port = 8860,
    this.host = '0.0.0.0',
    this.prismaClientDatasourceUrl,
  });

  Future<HttpServer> start() async {
    prismaClient = PrismaClient(
        datasourceUrl:
            prismaClientDatasourceUrl ?? Platform.environment['DATABASE_URL']);
    await prismaClient.$connect();

    final router = Router();
    router.mount(
        '/orders', OrderController(prismaClient: prismaClient).router.call);

    final handler = const shelf.Pipeline()
        .addMiddleware(shelf.logRequests())
        .addHandler(router.call);

    server = await io.serve(handler, host, port);
    return server;
  }

  Future<void> stop() async {
    await prismaClient.$disconnect();
    await server.close(force: true);
  }
}
