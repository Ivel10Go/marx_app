import 'dart:math';

import '../../data/models/daily_content.dart';
import '../../data/models/history_fact.dart';
import '../../data/models/home_content_mode.dart';
import '../../data/models/quote.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/repositories/quote_repository.dart';
import 'personalization_service.dart';

class DailyContentResolver {
  DailyContentResolver({PersonalizationService? personalization})
    : _personalization = personalization ?? PersonalizationService();

  final PersonalizationService _personalization;

  Future<DailyContent?> resolveDailyContentFromRepository({
    required QuoteRepository quoteRepository,
    required HistoryRepository historyRepository,
    required HomeContentMode homeContentMode,
    required AppMode appMode,
    required UserProfile profile,
    DateTime? now,
  }) async {
    final allQuotes = await quoteRepository.watchAllQuotes().first;
    final allFacts = await historyRepository.watchAllHistoryFacts().first;
    final issueNumber = _issueNumberFor(now ?? DateTime.now());

    if (homeContentMode == HomeContentMode.quotes) {
      return _resolveAsQuote(
        allQuotes: allQuotes,
        appMode: appMode,
        profile: profile,
        issueNumber: issueNumber,
      );
    }

    if (homeContentMode == HomeContentMode.facts) {
      return _resolveAsFactThenQuote(
        allFacts: allFacts,
        allQuotes: allQuotes,
        appMode: appMode,
        profile: profile,
        issueNumber: issueNumber,
      );
    }

    final preferFactFirst = Random(issueNumber + 41).nextBool();
    if (preferFactFirst) {
      return _resolveAsFactThenQuote(
        allFacts: allFacts,
        allQuotes: allQuotes,
        appMode: appMode,
        profile: profile,
        issueNumber: issueNumber,
      );
    }

    final quoteFirst = _resolveAsQuote(
      allQuotes: allQuotes,
      appMode: appMode,
      profile: profile,
      issueNumber: issueNumber,
    );
    if (quoteFirst != null) {
      return quoteFirst;
    }

    final factFallback = _resolveFact(
      allFacts: allFacts,
      profile: profile,
      issueNumber: issueNumber,
    );
    if (factFallback != null) {
      return DailyContent.fact(fact: factFallback);
    }

    return null;
  }

  DailyContent? _resolveAsFactThenQuote({
    required List<HistoryFact> allFacts,
    required List<Quote> allQuotes,
    required AppMode appMode,
    required UserProfile profile,
    required int issueNumber,
  }) {
    final fact = _resolveFact(
      allFacts: allFacts,
      profile: profile,
      issueNumber: issueNumber,
    );
    if (fact != null) {
      return DailyContent.fact(fact: fact);
    }

    return _resolveAsQuote(
      allQuotes: allQuotes,
      appMode: appMode,
      profile: profile,
      issueNumber: issueNumber,
    );
  }

  DailyContent? _resolveAsQuote({
    required List<Quote> allQuotes,
    required AppMode appMode,
    required UserProfile profile,
    required int issueNumber,
  }) {
    final quote = _resolveQuote(
      allQuotes: allQuotes,
      appMode: appMode,
      profile: profile,
      issueNumber: issueNumber,
    );
    if (quote == null) {
      return null;
    }
    return DailyContent.quote(quote: quote);
  }

  Future<List<Quote>> resolvePremiumQuoteFeed({
    required QuoteRepository quoteRepository,
    required AppMode appMode,
    required UserProfile profile,
    required int count,
    DateTime? now,
  }) async {
    final allQuotes = await quoteRepository.watchAllQuotes().first;
    if (allQuotes.isEmpty || count <= 0) {
      return <Quote>[];
    }

    final issueNumber = _issueNumberFor(now ?? DateTime.now());
    final scopedQuotes = _scopedQuotes(
      allQuotes: allQuotes,
      appMode: appMode,
      profile: profile,
    );
    final candidates = scopedQuotes.isEmpty ? allQuotes : scopedQuotes;
    if (profile.historicalInterests.isEmpty) {
      return <Quote>[];
    }

    final selected = <Quote>[];
    final seenIds = <String>{};
    final seenContentKeys = <String>{};

    for (var i = 0; i < profile.historicalInterests.length; i++) {
      final interest = profile.historicalInterests[i].trim().toLowerCase();
      if (interest.isEmpty) {
        continue;
      }

      final interestCandidates = candidates
          .where((quote) => _matchesInterest(quote, interest))
          .toList();
      if (interestCandidates.isEmpty) {
        continue;
      }

      final weightedInterest = _personalization.getWeightedQuotes(
        interestCandidates,
        profile,
      );
      if (weightedInterest.isEmpty) {
        continue;
      }

      final shuffledInterest = List<Quote>.from(weightedInterest)
        ..shuffle(Random(issueNumber + 73 + i));

      for (final quote in shuffledInterest) {
        final contentKey = _quoteContentKey(quote);
        if (seenIds.add(quote.id) && seenContentKeys.add(contentKey)) {
          selected.add(quote);
          break;
        }
      }
    }

    if (selected.length >= count) {
      return selected.take(count).toList();
    }

    final weighted = _personalization.getWeightedQuotes(candidates, profile);
    if (weighted.isEmpty) {
      return selected;
    }

    final shuffled = List<Quote>.from(weighted)
      ..shuffle(Random(issueNumber + 177));

    for (final quote in shuffled) {
      final contentKey = _quoteContentKey(quote);
      if (seenIds.add(quote.id) && seenContentKeys.add(contentKey)) {
        selected.add(quote);
      }

      if (selected.length == count) {
        break;
      }
    }

    return selected;
  }

  bool _matchesInterest(Quote quote, String interest) {
    return quote.category.any((category) {
      final normalizedCategory = category.toLowerCase();
      return normalizedCategory.contains(interest);
    });
  }

  String _quoteContentKey(Quote quote) {
    final text = quote.textDe.trim().toLowerCase();
    final source = quote.source.trim().toLowerCase();
    return '$source::$text';
  }

  Quote? _resolveQuote({
    required List<Quote> allQuotes,
    required AppMode appMode,
    required UserProfile profile,
    required int issueNumber,
  }) {
    final scopedQuotes = _scopedQuotes(
      allQuotes: allQuotes,
      appMode: appMode,
      profile: profile,
    );

    final candidates = scopedQuotes.isEmpty ? allQuotes : scopedQuotes;
    final weighted = _personalization.getWeightedQuotes(candidates, profile);
    if (weighted.isEmpty) {
      return null;
    }

    final random = Random(issueNumber + 11);
    return weighted[random.nextInt(weighted.length)];
  }

  HistoryFact? _resolveFact({
    required List<HistoryFact> allFacts,
    required UserProfile profile,
    required int issueNumber,
  }) {
    if (allFacts.isEmpty) {
      return null;
    }

    final weighted = _personalization.getWeightedFacts(allFacts, profile);
    if (weighted.isEmpty) {
      return null;
    }

    final random = Random(issueNumber + 29);
    return weighted[random.nextInt(weighted.length)];
  }

  List<Quote> _scopedQuotes({
    required List<Quote> allQuotes,
    required AppMode appMode,
    required UserProfile profile,
  }) {
    // Content filtering is intentionally limited to theme/interests + political orientation.
    return allQuotes;
  }

  int _issueNumberFor(DateTime now) {
    final epoch = DateTime(2000, 1, 1);
    return now.difference(epoch).inDays;
  }
}
