import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import 'app.dart';
import 'core/bootstrap/app_bootstrap.dart';
import 'core/router/app_router.dart';
import 'worker/daily_widget_worker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HomeWidget.setAppGroupId('group.com.example.marx_app');
  await registerDailyWidgetTask();

  final bootstrapResult = await AppBootstrap.initialize();

  runApp(
    ProviderScope(
      overrides: <Override>[
        initialRouteProvider.overrideWithValue(bootstrapResult.initialRoute),
      ],
      child: const DasKapitalApp(),
    ),
  );
}
