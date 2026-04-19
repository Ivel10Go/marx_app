import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';
part 'quote_dao.dart';
part 'history_fact_dao.dart';
part 'app_open_log_dao.dart';

@DriftDatabase(
  tables: [QuoteEntries, Favorites, SeenQuotes, HistoryFactEntries, AppOpenLog],
  daos: [QuoteDao, HistoryFactDao, AppOpenLogDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(historyFactEntries);
      }
      if (from < 3) {
        await m.createTable(appOpenLog);
      }
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'marx_app.sqlite');
}
