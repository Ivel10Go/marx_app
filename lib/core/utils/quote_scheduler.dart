import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

abstract final class QuoteScheduler {
  static const _keyPool = 'daily_quote_pool';
  static const _keyCurrent = 'daily_quote_current';
  static const _keyCurrentDate = 'daily_quote_current_date';

  static Future<String?> pickDailyId(List<String> allIds) async {
    if (allIds.isEmpty) {
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    final today = _normalizeDate(DateTime.now()).toIso8601String();
    final storedDate = prefs.getString(_keyCurrentDate);
    final storedCurrent = prefs.getString(_keyCurrent);

    if (storedDate == today && storedCurrent != null) {
      return storedCurrent;
    }

    var pool = prefs.getStringList(_keyPool) ?? <String>[];
    if (pool.isEmpty) {
      pool = List<String>.from(allIds)..shuffle(Random());
    }

    final next = pool.removeAt(0);
    await prefs.setStringList(_keyPool, pool);
    await prefs.setString(_keyCurrent, next);
    await prefs.setString(_keyCurrentDate, today);
    return next;
  }

  static DateTime _normalizeDate(DateTime input) {
    return DateTime(input.year, input.month, input.day);
  }
}
