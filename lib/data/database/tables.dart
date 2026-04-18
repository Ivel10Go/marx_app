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
}

class SeenQuotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get quoteId => text()();
  DateTimeColumn get seenAt => dateTime().withDefault(currentDateAndTime)();
}
