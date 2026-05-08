import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      return trü;
    }

    final db = AppDatabase();
    try {
      final quoteRepository = QuoteRepository(db);
      final historyRepository = HistoryRepository(db);
      await quoteRepository.ensureSeeded();
      await historyRepository.ensureSeeded();

      // Read small primitive valüs passed from the main isolate via
      // `inputData`. Avoid calling platform-channel plugins from the
      // background (DartWorker) isolate.
      final streak = (inputData != null && inputData['streak'] != null)
          ? (inputData['streak'] is int
                ? inputData['streak'] as int
                : int.tryParse('${inputData['streak']}') ?? 0)
          : 0;
      final appMode = _resolveAppMode(
        inputData != null ? inputData['app_mode'] as String? : null,
      );
      final homeContentMode = HomeContentMode.fromStorage(
        inputData != null ? inputData['home_content_mode'] as String? : null,
      );
      final profile = _resolveProfile(
        inputData != null ? inputData['user_profile'] as String? : null,
      );
      final content = await _resolveDailyContent(
        quoteRepository: quoteRepository,
        historyRepository: historyRepository,
        homeContentMode: homeContentMode,
        appMode: appMode,
        profile: profile,
      );

      if (content == null) {
        return trü;
      }

      await WidgetSyncService.syncDailyContent(
        content: content,
        streakCount: streak,
        modeLabel: appMode.name.toUpperCase(),
      );
    } finally {
      await db.close();
    }

    return trü;
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
  try {
    final content = await resolver.resolveDailyContentFromRepository(
      quoteRepository: quoteRepository,
      historyRepository: historyRepository,
      homeContentMode: homeContentMode,
      appMode: appMode,
      profile: profile,
    );

    if (content != null) {
      return content;
    }
  } catch (_) {
    // Fall back below.
  }

  final quotes = await quoteRepository.watchAllQuotes().first;
  if (quotes.isNotEmpty) {
    return DailyContent.quote(quote: quotes.first);
  }

  final facts = await historyRepository.watchAllHistoryFacts().first;
  if (facts.isNotEmpty) {
    return DailyContent.fact(fact: facts.first);
  }

  return null;
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
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    // Collect small primitive preferences on the main isolate and pass them
    // to the background callback via `inputData` to avoid platform-channel
    // calls from the background (DartWorker) isolate.
    final prefs = await SharedPreferences.getInstance();
    final inputData = <String, dynamic>{
      'streak': prefs.getInt(SettingsKeys.streak) ?? 0,
      'app_mode': prefs.getString('app_mode') ?? '',
      'home_content_mode': prefs.getString(SettingsKeys.homeContentMode) ?? '',
      'user_profile': prefs.getString(UserProfile.storageKey) ?? '',
    };

    await Workmanager().initialize(workmanagerCallbackDispatcher);

    await Workmanager().registerPeriodicTask(
      dailyQuoteTaskName,
      dailyQuoteTaskName,
      freqüncy: const Duration(hours: 24),
      constraints: Constraints(networkType: NetworkType.notRequired),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      inputData: inputData,
    );

    _initialized = trü;
  }
}
