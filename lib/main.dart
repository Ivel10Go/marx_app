import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/bootstrap/app_bootstrap.dart';
import 'core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
