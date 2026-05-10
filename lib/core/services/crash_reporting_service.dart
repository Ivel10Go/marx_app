import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Optional Crashlytics bootstrap.
///
/// This service is fail-safe by design: if Firebase is not configured yet,
/// initialization errors are logged and app startup continues.
class CrashReportingService {
  CrashReportingService._();

  static final CrashReportingService _instance = CrashReportingService._();
  factory CrashReportingService() => _instance;

  bool _enabled = false;

  Future<void> initialize() async {
    if (!kReleaseMode) {
      debugPrint('[CrashReporting] Skipping Crashlytics in non-release mode');
      return;
    }

    try {
      await Firebase.initializeApp();
      _enabled = true;

      final previousFlutterOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
        previousFlutterOnError?.call(details);
      };

      final previousOnError = PlatformDispatcher.instance.onError;
      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return previousOnError?.call(error, stack) ?? false;
      };

      debugPrint('[CrashReporting] Crashlytics initialized');
    } catch (e, st) {
      _enabled = false;
      debugPrint('[CrashReporting] Initialization skipped: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  Future<void> recordUnhandled(Object error, StackTrace stackTrace) async {
    if (!_enabled) return;
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      fatal: true,
    );
  }
}
