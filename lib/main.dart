import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import 'app.dart';
import 'core/bootstrap/app_bootstrap.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/loading/app_loading_screen.dart';
import 'worker/daily_widget_worker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HomeWidget.setAppGroupId('group.com.example.marx_app');
  await registerDailyWidgetTask();

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
    return FutureBuilder<AppBootstrapResult>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: const AppLoadingScreen(),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
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
                      ElevatedButton(
                        onPressed: () {
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

        return ProviderScope(
          overrides: <Override>[
            initialRouteProvider.overrideWithValue(snapshot.data!.initialRoute),
          ],
          child: const DasKapitalApp(),
        );
      },
    );
  }
}
