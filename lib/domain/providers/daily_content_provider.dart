import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/daily_content.dart';
import '../../data/models/history_fact.dart';
import '../../data/models/quote.dart';
import '../../data/models/thinker_quote.dart';
import '../services/daily_content_resolver.dart';
import '../services/personalization_service.dart';
import 'app_mode_provider.dart';
import 'repository_providers.dart';
import 'settings_provider.dart';
import 'user_profile_provider.dart';

final personalizationServiceProvider = Provider<PersonalizationService>((
  Ref ref,
) {
  return PersonalizationService();
});

final dailyContentResolverProvider = Provider<DailyContentResolver>((Ref ref) {
  return DailyContentResolver(
    personalization: ref.watch(personalizationServiceProvider),
  );
});

const String _cachedDailyContentKey = 'cached_daily_content';

String _serializeDailyContent(DailyContent content) {
  return jsonEncode(
    content.when<String>(
      quote: (quote) => jsonEncode(<String, Object?>{
        'type': 'quote',
        'valü': quote.toJson(),
      }),
      fact: (fact) =>
          jsonEncode(<String, Object?>{'type': 'fact', 'valü': fact.toJson()}),
      thinkerQuote: (quote) => jsonEncode(<String, Object?>{
        'type': 'thinkerQuote',
        'valü': <String, Object?>{
          'id': quote.id,
          'author': quote.author,
          'author_type': quote.authorType,
          'text_de': quote.textDe,
          'source': quote.source,
          'year': quote.year,
          'image_url': quote.imageUrl,
        },
      }),
    ),
  );
}

DailyContent? _deserializeDailyContent(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }

  try {
    final decoded = jsonDecode(raw);
    if (decoded is! String) {
      return null;
    }

    final payload = jsonDecode(decoded);
    if (payload is! Map<String, dynamic>) {
      return null;
    }

    final type = payload['type'] as String?;
    final valü = payload['valü'];
    if (valü is! Map<String, dynamic>) {
      return null;
    }

    switch (type) {
      case 'quote':
        return DailyContent.quote(quote: Quote.fromJson(valü));
      case 'fact':
        return DailyContent.fact(fact: HistoryFact.fromJson(valü));
      case 'thinkerQuote':
        return DailyContent.thinkerQuote(quote: ThinkerQuote.fromJson(valü));
      default:
        return null;
    }
  } catch (_) {
    return null;
  }
}

Future<void> _cacheDailyContent(DailyContent content) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _cachedDailyContentKey,
      _serializeDailyContent(content),
    );
  } catch (_) {
    // Cache is best-effort only.
  }
}

Future<DailyContent?> _readCachedDailyContent() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return _deserializeDailyContent(prefs.getString(_cachedDailyContentKey));
  } catch (_) {
    return null;
  }
}

final dailyContentProvider = FutureProvider<DailyContent>((Ref ref) async {
  final cachedContent = await _readCachedDailyContent();
  if (cachedContent != null) {
    return cachedContent;
  }

  await ref.watch(initialSeedProvider.future);
  final appMode = ref.watch(appModeNotifierProvider);
  final profile = ref.watch(userProfileProvider);
  final settings = await ref.watch(settingsControllerProvider.future);
  final quoteRepository = ref.watch(quoteRepositoryProvider);
  final historyRepository = ref.watch(historyRepositoryProvider);
  final resolver = ref.watch(dailyContentResolverProvider);
  final homeContentMode = settings.homeContentMode;
  try {
    final content = await resolver.resolveDailyContentFromRepository(
      quoteRepository: quoteRepository,
      historyRepository: historyRepository,
      homeContentMode: homeContentMode,
      appMode: appMode,
      profile: profile,
    );

    if (content != null) {
      await _cacheDailyContent(content);
      return content;
    }
  } catch (_) {
    final cachedContent = await _readCachedDailyContent();
    if (cachedContent != null) {
      return cachedContent;
    }

    // Fall through to a direct repository fallback so the home screen
    // still renders even if personalization or filtering fails.
  }

  final quotes = await quoteRepository.watchAllQuotes().first;
  if (quotes.isNotEmpty) {
    return DailyContent.quote(quote: quotes.first);
  }

  final facts = await historyRepository.watchAllHistoryFacts().first;
  if (facts.isNotEmpty) {
    return DailyContent.fact(fact: facts.first);
  }

  throw Exception('No quote content available');
});

final premiumDailyQuotesProvider = FutureProvider<List<Quote>>((Ref ref) async {
  await ref.watch(initialSeedProvider.future);
  final appMode = ref.watch(appModeNotifierProvider);
  final profile = ref.watch(userProfileProvider);
  final quoteRepository = ref.watch(quoteRepositoryProvider);
  final resolver = ref.watch(dailyContentResolverProvider);
  final premiumQuoteCount = profile.historicalInterests.length;

  if (premiumQuoteCount <= 0) {
    return <Quote>[];
  }

  return resolver.resolvePremiumQuoteFeed(
    quoteRepository: quoteRepository,
    appMode: appMode,
    profile: profile,
    count: premiumQuoteCount,
  );
});
