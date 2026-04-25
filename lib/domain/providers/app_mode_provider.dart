import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/daily_content.dart';

class AppModeNotifier extends StateNotifier<AppMode> {
  AppModeNotifier() : super(AppMode.public) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    state = _parseMode(prefs.getString('app_mode'));
  }

  Future<void> set(AppMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_mode', mode.name);
    state = mode;
  }

  AppMode _parseMode(String? stored) {
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
}

final appModeNotifierProvider = StateNotifierProvider<AppModeNotifier, AppMode>(
  (Ref ref) => AppModeNotifier(),
);
