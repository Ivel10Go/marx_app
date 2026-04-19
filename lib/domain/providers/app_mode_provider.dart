import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/daily_content.dart';

class AppModeNotifier extends StateNotifier<AppMode> {
  AppModeNotifier() : super(AppMode.marx) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('app_mode') ?? 'marx';
    try {
      state = AppMode.values.byName(stored);
    } catch (e) {
      state = AppMode.marx;
    }
  }

  Future<void> set(AppMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_mode', mode.name);
    state = mode;
  }
}

final appModeNotifierProvider = StateNotifierProvider<AppModeNotifier, AppMode>(
  (Ref ref) => AppModeNotifier(),
);
