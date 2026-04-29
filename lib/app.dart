import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'domain/providers/settings_provider.dart';

class DasKapitalApp extends ConsumerWidget {
  const DasKapitalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsControllerProvider);

    return settings.when(
      data: (settingsState) => MaterialApp.router(
        title: 'Zitatatlas',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: settingsState.themeMode,
        routerConfig: router,
      ),
      loading: () => MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator(color: AppColors.red)),
        ),
      ),
      error: (err, stack) => MaterialApp(
        home: Scaffold(body: Center(child: Text('Error: $err'))),
      ),
    );
  }
}
