import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/daily_content.dart';
import '../../data/models/quote.dart';
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

final dailyContentProvider = FutureProvider<DailyContent>((Ref ref) async {
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
      return content;
    }
  } catch (_) {
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
