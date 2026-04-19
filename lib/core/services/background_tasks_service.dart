import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../data/database/app_database.dart';
import '../../data/models/daily_content.dart';
import '../../data/repositories/history_repository.dart';
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

      if (content == null) {
        return true;
      }

      await WidgetSyncService.syncDailyContent(
        content: content,
        streakCount: streak,
      );

      final quote = content.when(quote: (q) => q, fact: (_) => null);
      if (quote != null) {
        await NotificationService.instance.showDailyQuote(quote);
      }
    } finally {
      await db.close();
    }

    return true;
  });
}

Future<DailyContent?> _resolveDailyContent({
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

int _getIssueNumber() {
  final now = DateTime.now();
  final epoch = DateTime(2000, 1, 1);
  return now.difference(epoch).inDays;
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
