import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/database/app_database.dart';
import '../../data/models/daily_content.dart';
import '../../data/models/home_content_mode.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/repositories/quote_repository.dart';
import '../../domain/services/daily_content_resolver.dart';
import '../constants/settings_keys.dart';
import '../services/notification_service.dart';
import '../services/widget_sync_service.dart';
import '../services/purchases_service.dart';
import '../theme/app_theme.dart';

class _IsolateDailyContent {
  _IsolateDailyContent({
    required this.content,
    required this.streakCount,
    required this.appMode,
  });
  final DailyContent? content;
  final int streakCount;
  final String appMode;
}

/// Deferred background warm-up (runs after first frame in isolate).
/// Only resolves content - seeding must be done in main thread first.
Future<_IsolateDailyContent> _initializeDatabaseInIsolate(
  Map<String, Object?> args,
) async {
  final db = AppDatabase();
  final stopwatch = Stopwatch()..start();
  try {
    debugPrint('[DeferredData] Starting content resolution in isolate...');
    final quoteRepository = QuoteRepository(db);
    final historyRepository = HistoryRepository(db);

    // Parse persisted settings passed from main isolate.
    final prefsStart = Stopwatch()..start();
    final streak = (args[SettingsKeys.streak] as int?) ?? 0;
    final appMode = AppBootstrap._resolveAppMode(args['app_mode'] as String?);
    final homeContentMode = HomeContentMode.fromStorage(
      args[SettingsKeys.homeContentMode] as String?,
    );
    final profile = AppBootstrap._resolveProfile(
      args[UserProfile.storageKey] as String?,
    );
    prefsStart.stop();
    debugPrint(
      '[DeferredData] Preferences fetched in ${prefsStart.elapsedMilliseconds}ms',
    );

    // Resolve daily content
    final contentStart = Stopwatch()..start();
    final resolver = DailyContentResolver();
    final content = await AppBootstrap._resolveDailyContent(
      quoteRepository: quoteRepository,
      historyRepository: historyRepository,
      homeContentMode: homeContentMode,
      appMode: appMode,
      profile: profile,
      resolver: resolver,
    );
    contentStart.stop();
    debugPrint(
      '[DeferredData] Daily content resolved in ${contentStart.elapsedMilliseconds}ms',
    );

    debugPrint(
      '[DeferredData] Database initialization completed in ${stopwatch.elapsedMilliseconds}ms',
    );

    return _IsolateDailyContent(
      content: content,
      streakCount: streak,
      appMode: appMode.name.toUpperCase(),
    );
  } catch (e, st) {
    debugPrint('[DeferredData] ERROR during database initialization: $e');
    debugPrintStack(stackTrace: st);
    rethrow;
  } finally {
    try {
      await db.close();
      debugPrint('[DeferredData] Database connection closed');
    } catch (e) {
      debugPrint('[DeferredData] ERROR closing database: $e');
    }
  }
}

class AppBootstrapResult {
  const AppBootstrapResult({
    required this.initialRoute,
    required this.dailyContent,
    required this.streakCount,
    required this.modeLabel,
  });

  final String initialRoute;
  final DailyContent? dailyContent;
  final int streakCount;
  final String modeLabel;
}

class AppBootstrapProgress {
  const AppBootstrapProgress({required this.progress, required this.message});

  final double progress;
  final String message;
}

abstract final class AppBootstrap {
  static final StreamController<AppBootstrapProgress> _progressController =
      StreamController<AppBootstrapProgress>.broadcast();

  static Stream<AppBootstrapProgress> get progressStream =>
      _progressController.stream;

  static void _emitProgress(double progress, String message) {
    if (_progressController.isClosed) {
      return;
    }

    _progressController.add(
      AppBootstrapProgress(
        progress: progress.clamp(0.0, 1.0),
        message: message,
      ),
    );
  }

  static Future<AppBootstrapResult> initialize() async {
    try {
      debugPrint('[Bootstrap] Starting app bootstrap...');
      _emitProgress(0.05, 'Start wird vorbereitet ...');

      // Initialize fonts early - disable runtime fetching and preload critical fonts
      final fontStart = Stopwatch()..start();
      debugPrint('[Bootstrap] Initializing fonts...');
      _emitProgress(0.10, 'Schriftarten werden geladen ...');

      // Fallback to runtime fetching when bundled font files are not present.
      // This avoids crashes like "font ... was not found in application assets".
      GoogleFonts.config.allowRuntimeFetching = true;
      AppTheme.initializeTextStyles(); // Preload all text styles

      fontStart.stop();
      debugPrint(
        '[Bootstrap] Fonts initialized in ${fontStart.elapsedMilliseconds}ms',
      );
      _emitProgress(0.15, 'Benachrichtigungen werden vorbereitet ...');

      unawaited(_initializeNotificationService());

      // Initialize RevenueCat Purchases SDK (non-fatal, short timeout)
      try {
        _emitProgress(0.18, 'Zahlungsdienste werden initialisiert ...');
        await PurchasesService.instance
            .init('test_PekobyLoTBNwtOUgnVmtfRCAclN', debugLogs: kDebugMode)
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                debugPrint('[Bootstrap] WARNING: RevenueCat init timed out');
                return;
              },
            );
        debugPrint('[Bootstrap] RevenueCat initialized');
      } catch (e, st) {
        debugPrint('[Bootstrap] RevenueCat init failed: $e');
        debugPrintStack(stackTrace: st);
        // Non-critical, continue startup
      }

      // Determine initial route from persisted settings only.
      final routeStart = Stopwatch()..start();
      debugPrint('[Bootstrap] Determining initial route...');
      _emitProgress(0.24, 'Startseite wird bestimmt ...');
      final settings = await SharedPreferences.getInstance();
      final profileRaw = settings.getString(UserProfile.storageKey);
      final onboardingSeen = _resolveOnboardingSeen(profileRaw);
      final launchRoute = NotificationService.instance.consumeLaunchRoute();
      final initialRoute = launchRoute != '/'
          ? launchRoute
          : onboardingSeen
          ? '/'
          : '/onboarding';
      routeStart.stop();
      debugPrint(
        '[Bootstrap] Initial route determined in ${routeStart.elapsedMilliseconds}ms',
      );
      _emitProgress(0.32, 'Start wird abgeschlossen ...');
      _emitProgress(1.0, 'Fertig ...');

      debugPrint(
        '[Bootstrap] ✓ Critical bootstrap completed quickly. Initial route: $initialRoute',
      );

      // Schedule deferred operations to run after app becomes visible.
      _scheduleDeferredOperations();

      return AppBootstrapResult(
        initialRoute: initialRoute,
        dailyContent: null,
        streakCount: settings.getInt(SettingsKeys.streak) ?? 0,
        modeLabel: _resolveAppMode(
          settings.getString('app_mode'),
        ).name.toUpperCase(),
      );
    } catch (e, st) {
      _emitProgress(1.0, 'Start fehlgeschlagen');
      debugPrint('[Bootstrap] FATAL ERROR: Bootstrap failed unexpectedly: $e');
      debugPrintStack(stackTrace: st);
      return _buildFallbackResult();
    }
  }

  /// Initialize notification service in background (doesn't block app startup)
  static Future<void> _initializeNotificationService() async {
    try {
      debugPrint(
        '[Bootstrap] Initializing notification service (background)...',
      );
      final notifStart = Stopwatch()..start();
      await NotificationService.instance.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint(
            '[Bootstrap] WARNING: Notification service init timed out',
          );
          return;
        },
      );
      notifStart.stop();
      debugPrint(
        '[Bootstrap] Notification service initialized in ${notifStart.elapsedMilliseconds}ms',
      );
    } catch (e, st) {
      debugPrint('[Bootstrap] ERROR: Notification service init failed: $e');
      debugPrintStack(stackTrace: st);
      // Non-critical, continue anyway
    }
  }

  /// Schedule deferred operations to run after app displays (non-blocking)
  static void _scheduleDeferredOperations() {
    // Run all deferred operations asynchronously after a short delay
    Future.delayed(const Duration(milliseconds: 500), () async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final isolateArgs = <String, Object?>{
          SettingsKeys.streak: prefs.getInt(SettingsKeys.streak),
          'app_mode': prefs.getString('app_mode'),
          SettingsKeys.homeContentMode: prefs.getString(
            SettingsKeys.homeContentMode,
          ),
          UserProfile.storageKey: prefs.getString(UserProfile.storageKey),
        };

        // Warm the database and sync the widget without blocking startup.
        // Use compute() to avoid database locks in main thread.
        final warmupStart = Stopwatch()..start();
        debugPrint(
          '[Deferred] Warming up data for widget sync (main isolate)...',
        );
        final dailyContentData = await _initializeDatabaseInIsolate(isolateArgs)
            .timeout(
              const Duration(seconds: 30),
              onTimeout: () {
                debugPrint('[Deferred] WARNING: Database warm-up timed out');
                return _IsolateDailyContent(
                  content: null,
                  streakCount: 0,
                  appMode: 'PUBLIC',
                );
              },
            );
        warmupStart.stop();
        debugPrint(
          '[Deferred] Data warm-up completed in ${warmupStart.elapsedMilliseconds}ms',
        );

        if (dailyContentData.content != null) {
          final syncStart = Stopwatch()..start();
          debugPrint('[Deferred] Syncing widget...');
          await WidgetSyncService.syncDailyContent(
            content: dailyContentData.content!,
            streakCount: dailyContentData.streakCount,
            modeLabel: dailyContentData.appMode,
          );
          syncStart.stop();
          debugPrint(
            '[Deferred] Widget synced in ${syncStart.elapsedMilliseconds}ms',
          );
        }

        // Schedule daily reminders
        final reminderStart = Stopwatch()..start();
        debugPrint('[Deferred] Scheduling daily reminders...');
        await NotificationService.instance
            .scheduleDailyReminderFromSettings()
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                debugPrint(
                  '[Deferred] WARNING: Daily reminder scheduling timed out',
                );
                return;
              },
            );
        reminderStart.stop();
        debugPrint(
          '[Deferred] Daily reminders scheduled in ${reminderStart.elapsedMilliseconds}ms',
        );

        debugPrint('[Deferred] ✓ All deferred operations completed');
      } catch (e, st) {
        debugPrint('[Deferred] ERROR: Deferred operations failed: $e');
        debugPrintStack(stackTrace: st);
        // Non-critical, app is already running
      }
    });
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
    required HistoryRepository historyRepository,
    required HomeContentMode homeContentMode,
    required AppMode appMode,
    required UserProfile profile,
    required DailyContentResolver resolver,
  }) async {
    return resolver.resolveDailyContentFromRepository(
      quoteRepository: quoteRepository,
      historyRepository: historyRepository,
      homeContentMode: homeContentMode,
      appMode: appMode,
      profile: profile,
    );
  }

  static UserProfile _resolveProfile(String? raw) {
    if (raw == null || raw.isEmpty) {
      return UserProfile.initial();
    }

    try {
      return UserProfile.fromJsonString(raw);
    } catch (_) {
      return UserProfile.initial();
    }
  }

  static AppMode _resolveAppMode(String? stored) {
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

  static Future<AppBootstrapResult> _buildFallbackResult() async {
    try {
      final settings = await SharedPreferences.getInstance();
      final profileRaw = settings.getString(UserProfile.storageKey);
      final onboardingSeen = _resolveOnboardingSeen(profileRaw);
      final launchRoute = NotificationService.instance.consumeLaunchRoute();
      return AppBootstrapResult(
        initialRoute: launchRoute != '/'
            ? launchRoute
            : onboardingSeen
            ? '/'
            : '/onboarding',
        dailyContent: null,
        streakCount: settings.getInt(SettingsKeys.streak) ?? 0,
        modeLabel: _resolveAppMode(
          settings.getString('app_mode'),
        ).name.toUpperCase(),
      );
    } catch (e, st) {
      debugPrint('[Bootstrap] ERROR: Fallback bootstrap also failed: $e');
      debugPrintStack(stackTrace: st);
      return const AppBootstrapResult(
        initialRoute: '/onboarding',
        dailyContent: null,
        streakCount: 0,
        modeLabel: 'PUBLIC',
      );
    }
  }
}
