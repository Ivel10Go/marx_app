import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/bootstrap/app_bootstrap.dart';
import 'core/router/app_router.dart';
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
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                home: Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            Icons.error_outline,
                            size: 40,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 12),
                          const Text('Start fehlgeschlagen.'),
                          const SizedBox(height: 8),
                          Text(
                            'Fehler: ${snapshot.error}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              debugPrint('[UI] User clicked retry');
                              setState(() {
                                _bootstrapFuture = AppBootstrap.initialize();
                              });
                            },
                            child: const Text('Erneut versuchen'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              debugPrint('[UI] Bootstrap completed but no data returned');
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                home: Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            Icons.error_outline,
                            size: 40,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 12),
                          const Text('Start fehlgeschlagen.'),
                          const SizedBox(height: 8),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              debugPrint('[UI] User clicked retry');
                              setState(() {
                                _bootstrapFuture = AppBootstrap.initialize();
                              });
                            },
                            child: const Text('Erneut versuchen'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
