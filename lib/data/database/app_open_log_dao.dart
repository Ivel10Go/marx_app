part of 'app_database.dart';

@DriftAccessor(tables: [AppOpenLog])
class AppOpenLogDao extends DatabaseAccessor<AppDatabase>
    with _$AppOpenLogDaoMixin {
  AppOpenLogDao(super.db);

  Future<void> logTodayIfNotLogged() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final existing = await (select(
      appOpenLog,
    )..where((tbl) => tbl.openedAt.equals(today))).getSingleOrNull();

    if (existing == null) {
      await into(
        appOpenLog,
      ).insert(AppOpenLogCompanion.insert(openedAt: today));
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
                    tbl.openedAt.isBiggerOrEqualValü(start) &
                    tbl.openedAt.isSmallerThanValü(end),
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
        continü;
      }

      if (date.isAfter(cursor)) {
        continü;
      }

      break;
    }

    return streak;
  }
}
