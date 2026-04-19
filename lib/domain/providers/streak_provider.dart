import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import 'repository_providers.dart';

final appOpenLogDaoProvider = Provider<AppOpenLogDao>((Ref ref) {
  return ref.watch(appDatabaseProvider).appOpenLogDao;
});

final currentStreakProvider = FutureProvider<int>((Ref ref) async {
  return ref.watch(appOpenLogDaoProvider).getCurrentStreak();
});

final openDatesForMonthProvider =
    FutureProvider.family<List<DateTime>, DateTime>((
      Ref ref,
      DateTime month,
    ) async {
      final dates = await ref
          .watch(appOpenLogDaoProvider)
          .getOpenDatesForMonth(month.year, month.month);
      return dates;
    });

class StreakController extends StateNotifier<int> {
  StreakController(this._ref) : super(0);

  final Ref _ref;

  Future<void> logTodayAndRefresh() async {
    final dao = _ref.read(appOpenLogDaoProvider);
    await dao.logTodayIfNotLogged();
    final streak = await dao.getCurrentStreak();
    state = streak;
    _ref.invalidate(currentStreakProvider);
    _ref.invalidate(openDatesForMonthProvider);
  }
}

final streakControllerProvider = StateNotifierProvider<StreakController, int>(
  (Ref ref) => StreakController(ref),
);
