import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import '../../data/models/daily_content.dart';
import '../../data/models/history_fact.dart';
import '../../data/models/quote.dart';
import '../../data/models/user_profile.dart';
import '../services/personalization_service.dart';
import 'app_mode_provider.dart';
import 'repository_providers.dart';
import 'user_profile_provider.dart';

final personalizationServiceProvider = Provider<PersonalizationService>((
  Ref ref,
) {
  return PersonalizationService();
});

final dailyContentProvider = FutureProvider<DailyContent>((Ref ref) async {
  await ref.watch(initialSeedProvider.future);
  final mode = ref.watch(appModeNotifierProvider);
  final profile = ref.watch(userProfileProvider);
  final quoteRepository = ref.watch(quoteRepositoryProvider);
  final factRepository = ref.watch(historyRepositoryProvider);
  final personalization = ref.watch(personalizationServiceProvider);
  final issueNumber = _getIssueNumber();

  final allQuotes = await quoteRepository.watchAllQuotes().first;
  final allFacts = await factRepository.watchAllHistoryFacts().first;

  switch (mode) {
    case AppMode.marx:
      final quote = _pickWeightedQuote(
        allQuotes,
        profile,
        issueNumber,
        personalization,
      );
      if (quote == null) {
        final fact = _pickWeightedFact(
          allFacts,
          profile,
          issueNumber,
          personalization,
        );
        if (fact != null) {
          return DailyContent.fact(fact: fact);
        }
        throw Exception('No content available');
      }
      return DailyContent.quote(quote: quote);

    case AppMode.history:
      final fact = _pickWeightedFact(
        allFacts,
        profile,
        issueNumber,
        personalization,
      );
      if (fact == null) {
        final quote = _pickWeightedQuote(
          allQuotes,
          profile,
          issueNumber,
          personalization,
        );
        if (quote != null) {
          return DailyContent.quote(quote: quote);
        }
        throw Exception('No content available');
      }
      return DailyContent.fact(fact: fact);

    case AppMode.mixed:
      if (issueNumber.isOdd) {
        final quote = _pickWeightedQuote(
          allQuotes,
          profile,
          issueNumber,
          personalization,
        );
        if (quote == null) {
          throw Exception('Quote not available for mixed mode');
        }
        return DailyContent.quote(quote: quote);
      } else {
        final fact = _pickWeightedFact(
          allFacts,
          profile,
          issueNumber,
          personalization,
        );
        if (fact == null) {
          throw Exception('Fact not available for mixed mode');
        }
        return DailyContent.fact(fact: fact);
      }
  }
});

Quote? _pickWeightedQuote(
  List<Quote> all,
  UserProfile profile,
  int issueNumber,
  PersonalizationService personalization,
) {
  if (all.isEmpty) {
    return null;
  }
  final weighted = personalization.getWeightedQuotes(all, profile);
  final random = Random(issueNumber + 11);
  return weighted[random.nextInt(weighted.length)];
}

HistoryFact? _pickWeightedFact(
  List<HistoryFact> all,
  UserProfile profile,
  int issueNumber,
  PersonalizationService personalization,
) {
  if (all.isEmpty) {
    return null;
  }
  final weighted = personalization.getWeightedFacts(all, profile);
  final random = Random(issueNumber + 29);
  return weighted[random.nextInt(weighted.length)];
}

/// Get a deterministic issue number based on days since epoch
int _getIssueNumber() {
  final now = DateTime.now();
  final epoch = DateTime(2000, 1, 1);
  return now.difference(epoch).inDays;
}
