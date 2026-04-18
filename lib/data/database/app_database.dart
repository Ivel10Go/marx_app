import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';
part 'quote_dao.dart';

@DriftDatabase(tables: [QuoteEntries, Favorites, SeenQuotes], daos: [QuoteDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'marx_app.sqlite');
}
