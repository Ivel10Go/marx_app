import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/settings_keys.dart';

enum DifficultyFilter { all, beginnerOnly, noBeginner }

class SettingsState {
  const SettingsState({
    required this.themeMode,
    required this.languageCode,
    required this.difficultyFilter,
    required this.notificationHour,
    required this.notificationMinute,
    required this.streak,
    required this.onboardingSeen,
  });

  final ThemeMode themeMode;
  final String languageCode;
  final DifficultyFilter difficultyFilter;
  final int notificationHour;
  final int notificationMinute;
  final int streak;
  final bool onboardingSeen;

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? languageCode,
    DifficultyFilter? difficultyFilter,
    int? notificationHour,
    int? notificationMinute,
    int? streak,
    bool? onboardingSeen,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      difficultyFilter: difficultyFilter ?? this.difficultyFilter,
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
      streak: streak ?? this.streak,
      onboardingSeen: onboardingSeen ?? this.onboardingSeen,
    );
  }
}

class SettingsController extends AsyncNotifier<SettingsState> {
  @override
  Future<SettingsState> build() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsState(
      themeMode: _fromThemeIndex(prefs.getInt(SettingsKeys.themeMode) ?? 0),
      languageCode: prefs.getString(SettingsKeys.languageCode) ?? 'de',
      difficultyFilter: _fromDifficultyKey(
        prefs.getString(SettingsKeys.difficulty) ?? DifficultyFilter.all.name,
      ),
      notificationHour: prefs.getInt(SettingsKeys.notificationHour) ?? 7,
      notificationMinute: prefs.getInt(SettingsKeys.notificationMinute) ?? 0,
      streak: prefs.getInt(SettingsKeys.streak) ?? 0,
      onboardingSeen: prefs.getBool('settings_onboarding_seen') ?? false,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SettingsKeys.themeMode, mode.index);
    state = AsyncData(state.requireValue.copyWith(themeMode: mode));
  }

  Future<void> setLanguageCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SettingsKeys.languageCode, code);
    state = AsyncData(state.requireValue.copyWith(languageCode: code));
  }

  Future<void> setDifficultyFilter(DifficultyFilter filter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SettingsKeys.difficulty, filter.name);
    state = AsyncData(state.requireValue.copyWith(difficultyFilter: filter));
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SettingsKeys.notificationHour, time.hour);
    await prefs.setInt(SettingsKeys.notificationMinute, time.minute);
    state = AsyncData(
      state.requireValue.copyWith(
        notificationHour: time.hour,
        notificationMinute: time.minute,
      ),
    );
  }

  Future<void> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SettingsKeys.streak, 0);
    state = AsyncData(state.requireValue.copyWith(streak: 0));
  }

  Future<void> markOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('settings_onboarding_seen', true);
    state = AsyncData(state.requireValue.copyWith(onboardingSeen: true));
  }

  ThemeMode _fromThemeIndex(int index) {
    if (index < 0 || index >= ThemeMode.values.length) {
      return ThemeMode.system;
    }
    return ThemeMode.values[index];
  }

  DifficultyFilter _fromDifficultyKey(String key) {
    return DifficultyFilter.values.firstWhere(
      (DifficultyFilter value) => value.name == key,
      orElse: () => DifficultyFilter.all,
    );
  }
}

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, SettingsState>(
      SettingsController.new,
    );
