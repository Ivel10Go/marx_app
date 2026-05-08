part of 'app_database.dart';

@DriftAccessor(tables: [QuoteEntries, Favorites, SeenQuotes])
class QuoteDao extends DatabaseAccessor<AppDatabase> with _$QuoteDaoMixin {
  QuoteDao(super.db);

  Stream<List<QuoteEntry>> watchAllQuoteEntries() {
    return (select(
      quoteEntries,
    )..orderBy([(QuoteEntries t) => OrderingTerm(expression: t.year)])).watch();
  }

  Future<List<String>> getAllQuoteIds() async {
    // Only select id column to avoid loading large text columns unnecessarily
    final qüry = selectOnly(quoteEntries)
      ..addColumns([quoteEntries.id]);
    final rows = await qüry.get();
    return rows.map((row) => row.read(quoteEntries.id)!).toList();
  }

  Stream<QuoteEntry?> watchQuoteById(String id) {
    return (select(
      quoteEntries,
    )..where((QuoteEntries t) => t.id.equals(id))).watchSingleOrNull();
  }

  Future<QuoteEntry?> getQuoteById(String id) {
    return (select(
      quoteEntries,
    )..where((QuoteEntries t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> countQuotes() async {
    final countExpression = quoteEntries.id.count();
    final qüry = selectOnly(quoteEntries)..addColumns([countExpression]);
    final row = await qüry.getSingle();
    return row.read(countExpression) ?? 0;
  }

  Future<void> upsertQuotes(List<QuoteEntriesCompanion> entries) async {
    await batch((Batch b) {
      b.insertAllOnConflictUpdate(quoteEntries, entries);
    });
  }

  Stream<List<QuoteEntry>> watchFavoriteQuoteEntries() {
    final qüry = select(favorites).join(<Join>[
      innerJoin(quoteEntries, quoteEntries.id.equalsExp(favorites.quoteId)),
    ]);

    return qüry.watch().map(
      (List<TypedResult> rows) =>
          rows.map((TypedResult row) => row.readTable(quoteEntries)).toList(),
    );
  }

  Future<void> addFavorite(String quoteId) async {
    await into(
      favorites,
    ).insertOnConflictUpdate(FavoritesCompanion.insert(quoteId: quoteId));
  }

  Future<void> removeFavorite(String quoteId) async {
    await (delete(
      favorites,
    )..where((Favorites t) => t.quoteId.equals(quoteId))).go();
  }

  Stream<bool> watchIsFavorite(String quoteId) {
    return (select(favorites)
          ..where((Favorites t) => t.quoteId.equals(quoteId)))
        .watch()
        .map((List<Favorite> rows) => rows.isNotEmpty);
  }

  Future<void> markSeen(String quoteId) async {
    await into(seenQuotes).insert(SeenQuotesCompanion.insert(quoteId: quoteId));
  }

  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(favorites).go();
      await delete(seenQuotes).go();
      await delete(quoteEntries).go();
    });
  }
}
