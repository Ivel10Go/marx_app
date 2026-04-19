import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_profile.dart';

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(UserProfile.initial()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(UserProfile.storageKey);
    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      state = UserProfile.fromJsonString(raw);
    } catch (_) {
      state = UserProfile.initial();
    }
  }

  Future<void> saveProfile({
    required List<String> historicalInterests,
    required PoliticalLeaning politicalLeaning,
    bool onboardingCompleted = true,
  }) async {
    final next = UserProfile(
      historicalInterests: historicalInterests,
      politicalLeaning: politicalLeaning,
      onboardingCompleted: onboardingCompleted,
      onboardingDate: DateTime.now(),
    );

    await _persist(next);
  }

  Future<void> updateInterests(List<String> interests) async {
    final next = state.copyWith(historicalInterests: interests);
    await _persist(next);
  }

  Future<void> updatePoliticalLeaning(PoliticalLeaning leaning) async {
    final next = state.copyWith(politicalLeaning: leaning);
    await _persist(next);
  }

  Future<void> resetProfile() async {
    final next = UserProfile.initial();
    await _persist(next);
  }

  Future<void> _persist(UserProfile next) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(UserProfile.storageKey, next.toJsonString());
    state = next;
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>(
      (Ref ref) => UserProfileNotifier(),
    );
