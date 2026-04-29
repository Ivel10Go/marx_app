import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumNotifier extends AsyncNotifier<bool> {
  static const String _premiumKey = 'is_premium';

  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_premiumKey) ?? false;
  }

  Future<void> setPremium(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, isPremium);
    state = AsyncData(isPremium);
  }

  Future<void> togglePremium() async {
    final current = state.maybeWhen(
      data: (value) => value,
      orElse: () => false,
    );
    await setPremium(!current);
  }
}

final isPremiumProvider = AsyncNotifierProvider<PremiumNotifier, bool>(
  PremiumNotifier.new,
);
