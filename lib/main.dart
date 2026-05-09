import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/bootstrap/app_bootstrap.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/loading/app_loading_screen.dart';
import 'core/services/background_tasks_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock app to portrait orientation only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Lade Umgebungsvariablen (.env file)
  await dotenv.load();

  // Initialisiere Supabase
  final supabaseUrl = dotenv.env['SUPABASE_URL']?.trim() ?? '';
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']?.trim() ?? '';

  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    try {
      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    } catch (e) {
      debugPrint('[Bootstrap] Supabase init failed: $e');
      // Continü anyway - Supabase is optional for offline mode
    }
  } else {
    debugPrint('[Bootstrap] Supabase credentials missing, skipping init');
  }

  // RevenueCat initialization is handled centrally in AppBootstrap via
  // `PurchasesService.initFromEnvironment(...)`. Avoid duplicate configuration here.

  unawaited(
    BackgroundTasksService.initialize().catchError((
      Object error,
      StackTrace stackTrace,
    ) {
      debugPrint('[Bootstrap] Background task init failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }),
  );

  runApp(const _BootstrapGateApp());
}

class _BootstrapGateApp extends StatefulWidget {
  const _BootstrapGateApp();

  @override
  State<_BootstrapGateApp> createState() => _BootstrapGateAppState();
}

class _BootstrapGateAppState extends State<_BootstrapGateApp> {
  late Future<AppBootstrapResult> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = AppBootstrap.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppBootstrapProgress>(
      stream: AppBootstrap.progressStream,
      initialData: const AppBootstrapProgress(
        progress: 0.06,
        message: 'Start wird vorbereitet ...',
      ),
      builder: (context, progressSnapshot) {
        return FutureBuilder<AppBootstrapResult>(
          future: _bootstrapFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              debugPrint(
                '[UI] Bootstrap still loading... (state: ${snapshot.connectionState})',
              );
              final progressData = progressSnapshot.data;
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                home: AppLoadingScreen(
                  subtitle:
                      progressData?.message ?? 'Inhalte werden vorbereitet ...',
                  progress: progressData?.progress,
                ),
              );
            }

            if (snapshot.hasError) {
              debugPrint('[UI] Bootstrap error: ${snapshot.error}');
              return AppFullscreenRecoveryScreen(
                title: 'Start fehlgeschlagen',
                message:
                    'Der Start konnte nicht vollständig abgeschlossen werden.',
                details: 'Fehler: ${snapshot.error}',
                onRetry: () {
                  debugPrint('[UI] User clicked retry');
                  setState(() {
                    _bootstrapFuture = AppBootstrap.initialize();
                  });
                },
              );
            }

            if (!snapshot.hasData) {
              debugPrint('[UI] Bootstrap completed but no data returned');
              return AppFullscreenRecoveryScreen(
                title: 'Start fehlgeschlagen',
                message: 'Der Start hat keine gültigen Daten geliefert.',
                details: 'Die App kann erneut geladen werden.',
                onRetry: () {
                  debugPrint('[UI] User clicked retry');
                  setState(() {
                    _bootstrapFuture = AppBootstrap.initialize();
                  });
                },
              );
            }

            debugPrint(
              '[UI] Bootstrap completed successfully. Route: ${snapshot.data!.initialRoute}',
            );
            return ProviderScope(
              overrides: <Override>[
                initialRouteProvider.overrideWithValue(
                  snapshot.data!.initialRoute,
                ),
              ],

              child: const DasKapitalApp(),
            );
          },
        );
      },
    );
  }
}
