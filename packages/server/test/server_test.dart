import 'package:flutter_test/flutter_test.dart';

import 'package:server/server.dart';

void main() {
  test('server bootstrap', () async {
    final server = Server(port: 8888, host: 'localhost');
    expect(server.port, 8888);
    expect(server.host, 'localhost');
    await server.start();
    await server.stop();
  });
}
