part of 'app_database.dart';

@DriftAccessor(tables: [AppOpenLog])
class AppOpenLogDao extends DatabaseAccessor<AppDatabase>
    with _$AppOpenLogDaoMixin {
  AppOpenLogDao(super.db);

  Future<void> logTodayIfNotLogged() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        await customInsert(
          'INSERT OR IGNORE INTO app_open_log (opened_at) VALUES (?)',
          variables: [Variable<DateTime>(today)],
        );
        return;
      } catch (error) {
        final message = error.toString();
        final isLocked =
            message.contains('database is locked') ||
            message.contains('SQLITE_BUSY');

        if (!isLocked || attempt == 2) {
          rethrow;
        }

        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    }
  }

  Future<List<DateTime>> getOpenDatesForMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = month == 12
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);

    final rows =
        await (select(appOpenLog)
              ..where(
                (tbl) =>
                    tbl.openedAt.isBiggerOrEqualValue(start) &
                    tbl.openedAt.isSmallerThanValue(end),
              )
              ..orderBy([(tbl) => OrderingTerm(expression: tbl.openedAt)]))
            .get();

    return rows.map((row) => row.openedAt).toList().cast<DateTime>();
  }

  Future<int> getCurrentStreak() async {
    final rows = await (select(
      appOpenLog,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.openedAt)])).get();

    if (rows.isEmpty) {
      return 0;
    }

    final openedDates =
        rows
            .map(
              (row) => DateTime(
                row.openedAt.year,
                row.openedAt.month,
                row.openedAt.day,
              ),
            )
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    var cursor = DateTime(today.year, today.month, today.day);
    var streak = 0;

    for (final date in openedDates) {
      if (date == cursor) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
        continue;
      }

      if (date.isAfter(cursor)) {
        continue;
      }

      break;
    }

    return streak;
  }
}
