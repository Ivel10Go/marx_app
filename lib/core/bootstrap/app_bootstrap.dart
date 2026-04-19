import 'package:shared_preferences/shared_preferences.dart';

import '../../data/database/app_database.dart';
import '../../data/models/daily_content.dart';
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
      final appModeName = prefs.getString('app_mode') ?? AppMode.marx.name;
      final mode = AppMode.values.firstWhere(
        (AppMode item) => item.name == appModeName,
        orElse: () => AppMode.marx,
      );

      final content = await _resolveDailyContent(
        mode: mode,
        quoteRepository: quoteRepository,
        historyRepository: historyRepository,
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

  static Future<DailyContent?> _resolveDailyContent({
    required AppMode mode,
    required QuoteRepository quoteRepository,
    required HistoryRepository historyRepository,
  }) async {
    switch (mode) {
      case AppMode.marx:
        final quote = await quoteRepository.getDailyQuote();
        return quote == null ? null : DailyContent.quote(quote: quote);
      case AppMode.history:
        final fact = await historyRepository.getDailyHistoryFact();
        return fact == null ? null : DailyContent.fact(fact: fact);
      case AppMode.mixed:
        final issueNumber = _getIssueNumber();
        if (issueNumber.isOdd) {
          final quote = await quoteRepository.getDailyQuote();
          return quote == null ? null : DailyContent.quote(quote: quote);
        }
        final fact = await historyRepository.getDailyHistoryFact();
        return fact == null ? null : DailyContent.fact(fact: fact);
    }
  }

  static int _getIssueNumber() {
    final now = DateTime.now();
    final epoch = DateTime(2000, 1, 1);
    return now.difference(epoch).inDays;
  }
}
