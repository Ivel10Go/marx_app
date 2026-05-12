import 'dart:convert';

enum PoliticalLeaning { left, centerLeft, neutral, liberal, conservative }

enum QuoteDiscoveryMode { interests }

class InterestOption {
  const InterestOption({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final String icon;
}

const List<InterestOption> availableInterests = <InterestOption>[
  InterestOption(id: 'revolution', label: 'Revolutionen', icon: '✊'),
  InterestOption(id: 'arbeit', label: 'Arbeit & Wirtschaft', icon: '⚙'),
  InterestOption(id: 'philosophie', label: 'Philosophie', icon: '💭'),
  InterestOption(id: 'krieg', label: 'Krieg & Frieden', icon: '⚔'),
  InterestOption(id: 'kolonial', label: 'Kolonialismus', icon: '🌍'),
  InterestOption(id: 'frauen', label: 'Frauengeschichte', icon: '♀'),
  InterestOption(id: 'frauenrechte', label: 'Frauenrechte', icon: '⚖'),
  InterestOption(id: 'wissenschaft', label: 'Wissenschaft', icon: '🔬'),
  InterestOption(id: 'kunst', label: 'Kunst & Kultur', icon: '🎨'),
  InterestOption(id: 'religion', label: 'Religion & Kirche', icon: '✝'),
  InterestOption(id: 'alltag', label: 'Alltag & Gesellschaft', icon: '🏘'),
];

class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.profileTitle,
    required this.avatarIndex,
    required this.avatarImageBase64,
    required this.xp,
    required this.unlockedBadges,
    required this.historicalInterests,
    required this.politicalLeaning,
    required this.quoteDiscoveryMode,
    required this.isAdmin,
    required this.premiumTestEnabled,
    required this.onboardingCompleted,
    required this.onboardingDate,
  });

  static const String storageKey = 'user_profile_json';

  final String displayName;
  final String profileTitle;
  final int avatarIndex;
  final String? avatarImageBase64;
  final int xp;
  final List<String> unlockedBadges;
  final List<String> historicalInterests;
  final PoliticalLeaning politicalLeaning;
  final QuoteDiscoveryMode quoteDiscoveryMode;
  final bool isAdmin;
  final bool premiumTestEnabled;
  final bool onboardingCompleted;
  final DateTime? onboardingDate;

  factory UserProfile.initial() {
    return const UserProfile(
      displayName: '',
      profileTitle: 'Genosse',
      avatarIndex: 0,
      avatarImageBase64: null,
      xp: 0,
      unlockedBadges: <String>[],
      historicalInterests: <String>[],
      politicalLeaning: PoliticalLeaning.neutral,
      quoteDiscoveryMode: QuoteDiscoveryMode.interests,
      isAdmin: false,
      premiumTestEnabled: false,
      onboardingCompleted: false,
      onboardingDate: null,
    );
  }

  UserProfile copyWith({
    String? displayName,
    String? profileTitle,
    int? avatarIndex,
    String? avatarImageBase64,
    int? xp,
    List<String>? unlockedBadges,
    List<String>? historicalInterests,
    PoliticalLeaning? politicalLeaning,
    QuoteDiscoveryMode? quoteDiscoveryMode,
    bool? isAdmin,
    bool? premiumTestEnabled,
    bool? onboardingCompleted,
    DateTime? onboardingDate,
  }) {
    return UserProfile(
      displayName: displayName ?? this.displayName,
      profileTitle: profileTitle ?? this.profileTitle,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      avatarImageBase64: avatarImageBase64 ?? this.avatarImageBase64,
      xp: xp ?? this.xp,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
      historicalInterests: historicalInterests ?? this.historicalInterests,
      politicalLeaning: politicalLeaning ?? this.politicalLeaning,
      quoteDiscoveryMode: quoteDiscoveryMode ?? this.quoteDiscoveryMode,
      isAdmin: isAdmin ?? this.isAdmin,
      premiumTestEnabled: premiumTestEnabled ?? this.premiumTestEnabled,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      onboardingDate: onboardingDate ?? this.onboardingDate,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'display_name': displayName,
      'profile_title': profileTitle,
      'avatar_index': avatarIndex,
      'avatar_image_base64': avatarImageBase64,
      'xp': xp,
      'unlocked_badges': unlockedBadges,
      'historical_interests': historicalInterests,
      'political_leaning': politicalLeaning.name,
      'quote_discovery_mode': quoteDiscoveryMode.name,
      'is_admin': isAdmin,
      'premium_test_enabled': premiumTestEnabled,
      'onboarding_completed': onboardingCompleted,
      'onboarding_date': onboardingDate?.toIso8601String(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      displayName: (json['display_name'] as String?) ?? '',
      profileTitle: (json['profile_title'] as String?) ?? 'Genosse',
      avatarIndex: _parseAvatarIndex(json['avatar_index']),
      avatarImageBase64: json['avatar_image_base64'] as String?,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      unlockedBadges: (json['unlocked_badges'] as List<dynamic>? ?? <dynamic>[])
          .cast<String>(),
      historicalInterests:
          (json['historical_interests'] as List<dynamic>? ?? <dynamic>[])
              .cast<String>(),
      politicalLeaning: PoliticalLeaning.values.byName(
        (json['political_leaning'] as String?) ?? PoliticalLeaning.neutral.name,
      ),
      quoteDiscoveryMode: _parseQuoteDiscoveryMode(
        json['quote_discovery_mode'] as String?,
      ),
      isAdmin: (json['is_admin'] as bool?) ?? false,
      premiumTestEnabled: (json['premium_test_enabled'] as bool?) ?? false,
      onboardingCompleted: (json['onboarding_completed'] as bool?) ?? false,
      onboardingDate: _tryParseDate(json['onboarding_date'] as String?),
    );
  }

  factory UserProfile.fromJsonString(String raw) {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return UserProfile.fromJson(decoded);
  }

  static DateTime? _tryParseDate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }

  static QuoteDiscoveryMode _parseQuoteDiscoveryMode(String? value) {
    return QuoteDiscoveryMode.interests;
  }

  static int _parseAvatarIndex(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}
