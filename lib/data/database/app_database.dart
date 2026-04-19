import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';
part 'quote_dao.dart';
part 'history_fact_dao.dart';

@DriftDatabase(
  tables: [QuoteEntries, Favorites, SeenQuotes, HistoryFactEntries],
  daos: [QuoteDao, HistoryFactDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(historyFactEntries);
      }
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'marx_app.sqlite');
}
