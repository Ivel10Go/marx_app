import 'package:shared_preferences/shared_preferences.dart';

import '../../data/database/app_database.dart';
import '../../data/models/daily_content.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/history_repository.dart';
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
      final quoteRepository = QuoteRepository(db);
      final historyRepository = HistoryRepository(db);
      await quoteRepository.ensureSeeded();
      await historyRepository.ensureSeeded();

      final prefs = await SharedPreferences.getInstance();
      final streak = prefs.getInt(SettingsKeys.streak) ?? 0;
      final content = await _resolveDailyContent(
        quoteRepository: quoteRepository,
      );

      if (content != null) {
        await WidgetSyncService.syncDailyContent(
          content: content,
          streakCount: streak,
        );
      }
    } finally {
      await db.close();
    }

    await BackgroundTasksService.initialize();

    final settings = await SharedPreferences.getInstance();
    final profileRaw = settings.getString(UserProfile.storageKey);
    final onboardingSeen = _resolveOnboardingSeen(profileRaw);
    final launchRoute = NotificationService.instance.consumeLaunchRoute();
    final initialRoute = launchRoute != '/'
        ? launchRoute
        : onboardingSeen
        ? '/'
        : '/onboarding';

    return AppBootstrapResult(initialRoute: initialRoute);
  }

  static bool _resolveOnboardingSeen(String? profileRaw) {
    if (profileRaw == null || profileRaw.isEmpty) {
      return false;
    }

    try {
      return UserProfile.fromJsonString(profileRaw).onboardingCompleted;
    } catch (_) {
      return false;
    }
  }

  static Future<DailyContent?> _resolveDailyContent({
    required QuoteRepository quoteRepository,
  }) async {
    final quote = await quoteRepository.getDailyQuote();
    return quote == null ? null : DailyContent.quote(quote: quote);
  }
}
