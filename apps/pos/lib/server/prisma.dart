import 'package:flutter/widgets.dart';
import 'package:orm_flutter/orm_flutter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos/prisma/client.dart';

late final PrismaClient _prismaClient;

Future<PrismaClient> createPrismaClient(
    [String? dbFileName = 'database.sqlite.db']) async {
  WidgetsFlutterBinding.ensureInitialized();

  final supportDir = await getApplicationSupportDirectory();
  final dbPath = join(supportDir.path, dbFileName);

  _prismaClient = PrismaClient(datasourceUrl: 'file:$dbPath');
  final engine = switch (_prismaClient.$engine) {
    LibraryEngine engine => engine,
    _ => null,
  };

  await _prismaClient.$connect();
  await engine?.applyMigrations(path: 'prisma/migrations');

  return _prismaClient;
}

Future<void> closePrisma() async {
  await _prismaClient.$disconnect();
}
