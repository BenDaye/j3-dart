import 'dart:io';

import 'package:pos/prisma/client.dart';
import 'package:pos/server/controllers/order/main.dart';
import 'package:pos/server/prisma.dart';

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

class Server {
  late HttpServer server;
  late PrismaClient prismaClient;

  final int port;
  final String host;

  Server({
    this.port = 8860,
    this.host = '0.0.0.0',
  });

  Future<HttpServer> start() async {
    prismaClient = await createPrismaClient();

    final router = Router();
    router.mount(
      '/orders',
      OrderController(prismaClient: prismaClient).router.call,
    );

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
