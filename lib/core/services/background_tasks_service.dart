import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/quote_repository.dart';
import '../constants/settings_keys.dart';
import 'notification_service.dart';
import 'widget_sync_service.dart';

const String dailyQuoteTaskName = 'daily_quote_refresh_task';

@pragma('vm:entry-point')
void workmanagerCallbackDispatcher() {
  Workmanager().executeTask((
    String task,
    Map<String, dynamic>? inputData,
  ) async {
    if (task != dailyQuoteTaskName) {
      return true;
    }

    final db = AppDatabase();
    try {
      final repo = QuoteRepository(db);
      await repo.ensureSeeded();
      final quote = await repo.getDailyQuote();
      if (quote == null) {
        return true;
      }

      final prefs = await SharedPreferences.getInstance();
      final streak = prefs.getInt(SettingsKeys.streak) ?? 0;

      await WidgetSyncService.syncQuote(quote: quote, streakCount: streak);
      await NotificationService.instance.showDailyQuote(quote);
    } finally {
      await db.close();
    }

    return true;
  });
}

abstract final class BackgroundTasksService {
  static Future<void> initialize() async {
    await Workmanager().initialize(workmanagerCallbackDispatcher);

    await Workmanager().registerPeriodicTask(
      dailyQuoteTaskName,
      dailyQuoteTaskName,
      frequency: const Duration(hours: 24),
      constraints: Constraints(networkType: NetworkType.notRequired),
    );
  }
}
