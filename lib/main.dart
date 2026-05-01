import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/bootstrap/app_bootstrap.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'presentation/loading/app_loading_screen.dart';
import 'core/services/background_tasks_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
              return _BootstrapRecoveryApp(
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
              return _BootstrapRecoveryApp(
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

class _BootstrapRecoveryApp extends StatelessWidget {
  const _BootstrapRecoveryApp({
    required this.message,
    required this.details,
    required this.onRetry,
  });

  final String message;
  final String details;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: Scaffold(
        backgroundColor: AppColors.paper,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: 440,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  border: Border.all(color: AppColors.ink, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(width: 44, height: 2, color: AppColors.red),
                    const SizedBox(height: 16),
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 36,
                      color: AppColors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Start fehlgeschlagen',
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(message, style: textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    Text(details, style: textTheme.labelSmall),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onRetry,
                        child: const Text('Erneut versuchen'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
