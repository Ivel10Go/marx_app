import 'package:drift/drift.dart';

class QuoteEntries extends Table {
  TextColumn get id => text()();
  TextColumn get textDe => text()();
  TextColumn get textOriginal => text()();
  TextColumn get source => text()();
  IntColumn get year => integer()();
  TextColumn get chapter => text()();
  TextColumn get categoryCsv => text()();
  TextColumn get difficulty => text()();
  TextColumn get series => text()();
  TextColumn get explanationShort => text()();
  TextColumn get explanationLong => text()();
  TextColumn get relatedIdsCsv => text()();
  TextColumn get funFact => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get quoteId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => <String>[
    // Index on quoteId for faster lookups when checking if a quote is favorite
    // (used by watchIsFavorite()) and for JOIN operations with quoteEntries
    'CREATE INDEX IF NOT EXISTS idx_favorites_quote_id ON favorites(quote_id)'
  ];
}

class SeenQuotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get quoteId => text()();
  DateTimeColumn get seenAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => <String>[
    // Index on quoteId for faster lookups when checking if a quote has been seen
    // and for JOIN operations with quoteEntries
    'CREATE INDEX IF NOT EXISTS idx_seen_quotes_quote_id ON seen_quotes(quote_id)',
    // Composite index on seenAt DESC for efficient historical queries and sorting
    'CREATE INDEX IF NOT EXISTS idx_seen_quotes_date_desc ON seen_quotes(seen_at DESC)'
  ];
}

class HistoryFactEntries extends Table {
  TextColumn get id => text()();
  TextColumn get headline => text()();
  TextColumn get body => text()();
  TextColumn get dateDisplay => text()();
  TextColumn get dateIso => text()();
  IntColumn get dayOfYear => integer()();
  TextColumn get era => text()();
  TextColumn get region => text()();
  TextColumn get categoryCsv => text()();
  TextColumn get difficulty => text()();
  TextColumn get person => text().nullable()();
  TextColumn get personRole => text().nullable()();
  TextColumn get connectionToMarx => text()();
  TextColumn get relatedQuoteIdsCsv => text()();
  TextColumn get funFact => text().nullable()();
  TextColumn get source => text().nullable()();
  BoolColumn get todayInHistory =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

class AppOpenLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get openedAt => dateTime()();

  @override
  List<String> get customConstraints => <String>['UNIQUE(opened_at)'];
}
