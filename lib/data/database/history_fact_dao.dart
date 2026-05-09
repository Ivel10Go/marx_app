part of 'app_database.dart';

@DriftAccessor(tables: [HistoryFactEntries])
class HistoryFactDao extends DatabaseAccessor<AppDatabase>
    with _$HistoryFactDaoMixin {
  HistoryFactDao(super.db);

  Stream<List<HistoryFactEntry>> watchAllHistoryFactEntries() {
    return (select(historyFactEntries)..orderBy([
          (HistoryFactEntries t) => OrderingTerm(expression: t.dayOfYear),
        ]))
        .watch();
  }

  Future<List<String>> getAllHistoryFactIds() async {
    final rows = await select(historyFactEntries).get();
    return rows.map((HistoryFactEntry row) => row.id).toList();
  }

  Stream<HistoryFactEntry?> watchHistoryFactById(String id) {
    return (select(
      historyFactEntries,
    )..where((HistoryFactEntries t) => t.id.equals(id))).watchSingleOrNull();
  }

  Future<HistoryFactEntry?> getHistoryFactById(String id) {
    return (select(
      historyFactEntries,
    )..where((HistoryFactEntries t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> countHistoryFacts() async {
    final countExpression = historyFactEntries.id.count();
    final query = selectOnly(historyFactEntries)..addColumns([countExpression]);
    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
  }

  Future<void> upsertHistoryFacts(
    List<HistoryFactEntriesCompanion> entries,
  ) async {
    await batch((Batch b) {
      b.insertAllOnConflictUpdate(historyFactEntries, entries);
    });
  }

  Future<void> clearAllHistoryFacts() async {
    await delete(historyFactEntries).go();
  }
}
