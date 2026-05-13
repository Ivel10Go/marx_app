import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/supabase_sync_service.dart';
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
    QuoteDiscoveryMode quoteDiscoveryMode = QuoteDiscoveryMode.interests,
    bool isAdmin = false,
    bool premiumTestEnabled = false,
    bool onboardingCompleted = true,
    String displayName = '',
    String profileTitle = 'Genosse',
    int avatarIndex = 0,
    String? avatarImageBase64,
    int xp = 0,
    List<String> unlockedBadges = const <String>[],
  }) async {
    final next = UserProfile(
      historicalInterests: historicalInterests,
      politicalLeaning: politicalLeaning,
      quoteDiscoveryMode: quoteDiscoveryMode,
      isAdmin: isAdmin,
      premiumTestEnabled: premiumTestEnabled,
      onboardingCompleted: onboardingCompleted,
      onboardingDate: DateTime.now(),
      displayName: displayName,
      profileTitle: profileTitle,
      avatarIndex: avatarIndex,
      avatarImageBase64: avatarImageBase64,
      xp: xp,
      unlockedBadges: unlockedBadges,
    );

    await _persist(next);
  }

  Future<void> updateIdentity({
    String? displayName,
    String? profileTitle,
    int? avatarIndex,
    String? avatarImageBase64,
  }) async {
    final next = state.copyWith(
      displayName: displayName,
      profileTitle: profileTitle,
      avatarIndex: avatarIndex,
      avatarImageBase64: avatarImageBase64,
    );
    await _persist(next);
  }

  Future<void> updateProgress({int? xp, List<String>? unlockedBadges}) async {
    final next = state.copyWith(xp: xp, unlockedBadges: unlockedBadges);
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

  Future<void> updateQuoteDiscoveryMode(QuoteDiscoveryMode mode) async {
    final next = state.copyWith(quoteDiscoveryMode: mode);
    await _persist(next);
  }

  Future<void> updateAdminAccess(bool isAdmin) async {
    final next = state.copyWith(isAdmin: isAdmin);
    await _persist(next);
  }

  Future<void> updatePremiumTestEnabled(bool enabled) async {
    final next = state.copyWith(premiumTestEnabled: enabled);
    await _persist(next);
  }

  Future<void> resetProfile() async {
    final next = UserProfile.initial();
    await _persist(next);
  }

  /// Lade UserProfile aus Cloud und speichere lokal
  /// Wird nach erfolgreichem Login aufgerufen
  Future<void> loadProfileFromCloud(String userId) async {
    try {
      final syncService = SupabaseSyncService();
      final cloudProfile = await syncService.fetchUserProfileFromCloud(userId);

      if (cloudProfile != null) {
        final displayName = cloudProfile['display_name'] as String?;
        final historicalInterests =
            cloudProfile['historical_interests'] as List<String>? ?? <String>[];
        final politicalLeaning = _parsePoliticalLeaning(
          cloudProfile['political_leaning'] as String?,
        );

        final next = state.copyWith(
          displayName: displayName,
          historicalInterests: historicalInterests,
          politicalLeaning: politicalLeaning,
        );
        await _persist(next);
      }
      // Wenn kein CloudProfile existiert, behält state den aktuellen Wert
    } catch (e) {
      // Log aber nicht fehlschlagen - Cloud-Sync ist nicht kritisch
      print('Error loading profile from cloud: $e');
    }
  }

  /// Speichere UserProfile zur Cloud
  Future<void> syncToCloud(String userId) async {
    try {
      final syncService = SupabaseSyncService();
      await syncService.syncUserProfileToCloud(
        userId: userId,
        displayName: state.displayName,
        historicalInterests: state.historicalInterests,
        politicalLeaning: state.politicalLeaning.name,
        onboardingCompleted: state.onboardingCompleted,
      );
    } catch (e) {
      // Log aber nicht fehlschlagen - Cloud-Sync ist nicht kritisch
      print('Error syncing profile to cloud: $e');
    }
  }

  /// Parse political leaning from string
  static PoliticalLeaning _parsePoliticalLeaning(String? value) {
    if (value == null) return PoliticalLeaning.neutral;
    try {
      return PoliticalLeaning.values.firstWhere(
        (e) => e.name == value,
        orElse: () => PoliticalLeaning.neutral,
      );
    } catch (_) {
      return PoliticalLeaning.neutral;
    }
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
