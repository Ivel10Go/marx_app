import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../core/constants/settings_keys.dart';
import '../core/utils/widget_updater.dart';
import '../data/database/app_database.dart';
import '../data/repositories/history_repository.dart';
import '../data/repositories/quote_repository.dart';

const taskName = 'dailyWidgetUpdate';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != taskName) {
      return true;
    }

    final db = AppDatabase();
    try {
      final quoteRepository = QuoteRepository(db);
      final historyRepository = HistoryRepository(db);
      await quoteRepository.ensureSeeded();
      await historyRepository.ensureSeeded();

      final prefs = await SharedPreferences.getInstance();
      final streak = prefs.getInt(SettingsKeys.streak) ?? 0;
      final quote = await quoteRepository.getDailyQuote();
      if (quote != null) {
        await WidgetUpdater.updateWithQuote(quote, streak);
      }
    } finally {
      await db.close();
    }

    return true;
  });
}

Future<void> registerDailyWidgetTask() async {
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    taskName,
    taskName,
    frequency: const Duration(hours: 24),
    initialDelay: const Duration(minutes: 1),
    constraints: Constraints(networkType: NetworkType.notRequired),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
  );
}
