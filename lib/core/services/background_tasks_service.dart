import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../data/database/app_database.dart';
import '../../data/models/daily_content.dart';
import '../../data/models/home_content_mode.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/repositories/quote_repository.dart';
import '../../domain/services/daily_content_resolver.dart';
import '../constants/settings_keys.dart';
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
      final appMode = _resolveAppMode(prefs.getString('app_mode'));
      final homeContentMode = HomeContentMode.fromStorage(
        prefs.getString(SettingsKeys.homeContentMode),
      );
      final profile = _resolveProfile(prefs.getString(UserProfile.storageKey));
      final content = await _resolveDailyContent(
        quoteRepository: quoteRepository,
        historyRepository: historyRepository,
        homeContentMode: homeContentMode,
        appMode: appMode,
        profile: profile,
      );

      if (content == null) {
        return true;
      }

      await WidgetSyncService.syncDailyContent(
        content: content,
        streakCount: streak,
        modeLabel: appMode.name.toUpperCase(),
      );
    } finally {
      await db.close();
    }

    return true;
  });
}

Future<DailyContent?> _resolveDailyContent({
  required QuoteRepository quoteRepository,
  required HistoryRepository historyRepository,
  required HomeContentMode homeContentMode,
  required AppMode appMode,
  required UserProfile profile,
}) async {
  final resolver = DailyContentResolver();
  return resolver.resolveDailyContentFromRepository(
    quoteRepository: quoteRepository,
    historyRepository: historyRepository,
    homeContentMode: homeContentMode,
    appMode: appMode,
    profile: profile,
  );
}

AppMode _resolveAppMode(String? stored) {
  switch (stored) {
    case 'adminMarx':
    case 'godmode':
      return AppMode.adminMarx;
    case 'public':
    case 'marx':
    case 'history':
    case 'mixed':
    default:
      return AppMode.public;
  }
}

UserProfile _resolveProfile(String? raw) {
  if (raw == null || raw.isEmpty) {
    return UserProfile.initial();
  }

  try {
    return UserProfile.fromJsonString(raw);
  } catch (_) {
    return UserProfile.initial();
  }
}

abstract final class BackgroundTasksService {
  static Future<void> initialize() async {
    await Workmanager().initialize(workmanagerCallbackDispatcher);

    await Workmanager().registerPeriodicTask(
      dailyQuoteTaskName,
      dailyQuoteTaskName,
      frequency: const Duration(hours: 24),
      constraints: Constraints(networkType: NetworkType.notRequired),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }
}
