import 'package:shared_preferences/shared_preferences.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/quote_repository.dart';
import '../constants/settings_keys.dart';
import '../services/background_tasks_service.dart';
import '../services/notification_service.dart';
import '../services/widget_sync_service.dart';

class AppBootstrapResult {
  const AppBootstrapResult({required this.initialRoute});

  final String initialRoute;
}

abstract final class AppBootstrap {
  static Future<AppBootstrapResult> initialize() async {
    await NotificationService.instance.initialize();

    final db = AppDatabase();
    try {
      final repo = QuoteRepository(db);
      await repo.ensureSeeded();
      final quote = await repo.getDailyQuote();

      if (quote != null) {
        final prefs = await SharedPreferences.getInstance();
        final streak = prefs.getInt(SettingsKeys.streak) ?? 0;
        await WidgetSyncService.syncQuote(quote: quote, streakCount: streak);
      }
    } finally {
      await db.close();
    }

    await BackgroundTasksService.initialize();

    final settings = await SharedPreferences.getInstance();
    final onboardingSeen =
        settings.getBool('settings_onboarding_seen') ?? false;
    final launchRoute = NotificationService.instance.consumeLaunchRoute();
    final initialRoute = launchRoute != '/'
        ? launchRoute
        : onboardingSeen
        ? '/'
        : '/onboarding';

    return AppBootstrapResult(initialRoute: initialRoute);
  }
}
