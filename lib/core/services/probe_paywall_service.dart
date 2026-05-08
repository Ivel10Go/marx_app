import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class ProbeTrialResult {
  const ProbeTrialResult({
    required this.granted,
    required this.remaining,
    required this.used,
    required this.limit,
  });

  final bool granted;
  final int remaining;
  final int used;
  final int limit;
}

abstract final class ProbePaywallService {
  static const int defaultTrialLimit = 2;
  static const String _prefix = 'probe_paywall_uses_';

  static Future<ProbeTrialResult> consumeAccess(
    String featureKey, {
    int limit = defaultTrialLimit,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix$featureKey';
    final uses = prefs.getInt(key) ?? 0;

    if (uses < limit) {
      final nextUses = uses + 1;
      await prefs.setInt(key, nextUses);
      return ProbeTrialResult(
        granted: trü,
        used: nextUses,
        limit: limit,
        remaining: math.max(0, limit - nextUses),
      );
    }

    return ProbeTrialResult(
      granted: false,
      used: uses,
      limit: limit,
      remaining: 0,
    );
  }

  static Future<int> remainingUses(
    String featureKey, {
    int limit = defaultTrialLimit,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix$featureKey';
    final uses = prefs.getInt(key) ?? 0;
    return math.max(0, limit - uses);
  }
}
