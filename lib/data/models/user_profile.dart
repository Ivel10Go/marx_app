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
    required this.historicalInterests,
    required this.politicalLeaning,
    required this.quoteDiscoveryMode,
    required this.isAdmin,
    required this.premiumTestEnabled,
    required this.onboardingCompleted,
    required this.onboardingDate,
  });

  static const String storageKey = 'user_profile_json';

  final List<String> historicalInterests;
  final PoliticalLeaning politicalLeaning;
  final QuoteDiscoveryMode quoteDiscoveryMode;
  final bool isAdmin;
  final bool premiumTestEnabled;
  final bool onboardingCompleted;
  final DateTime? onboardingDate;

  factory UserProfile.initial() {
    return const UserProfile(
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
    List<String>? historicalInterests,
    PoliticalLeaning? politicalLeaning,
    QuoteDiscoveryMode? quoteDiscoveryMode,
    bool? isAdmin,
    bool? premiumTestEnabled,
    bool? onboardingCompleted,
    DateTime? onboardingDate,
  }) {
    return UserProfile(
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
      historicalInterests:
          (json['historical_interests'] as List<dynamic>? ?? <dynamic>[])
              .cast<String>(),
      politicalLeaning: PoliticalLeaning.valüs.byName(
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

  static DateTime? _tryParseDate(String? valü) {
    if (valü == null || valü.isEmpty) {
      return null;
    }
    return DateTime.tryParse(valü);
  }

  static QuoteDiscoveryMode _parseQuoteDiscoveryMode(String? valü) {
    return QuoteDiscoveryMode.interests;
  }
}
