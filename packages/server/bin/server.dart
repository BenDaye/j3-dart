import 'dart:io';

import 'package:server/server.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';

void main(List<String> arguments) async {
  final port = int.tryParse(arguments
          .firstWhere((arg) => arg.startsWith('--port='),
              orElse: () => '--port=8080')
          .split('=')[1]) ??
      8080;
  final host = arguments
      .firstWhere((arg) => arg.startsWith('--host='),
          orElse: () => '--host=localhost')
      .split('=')[1];

  final server = Server(port: port, host: host);

  withHotreload(
    () => server.start(),
  );

  // 等待用户中断（Ctrl+C）
  await ProcessSignal.sigint.watch().first;
  await server.stop();
}
