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
    final profileScoped = _candidateQuotes(allQuotes, profile);
    final candidates = profileScoped.isEmpty ? allQuotes : profileScoped;

    if (appMode != AppMode.adminMarx) {
      return candidates;
    }

    final adminQuotes = candidates.where(_isAdminQuote).toList();
    return adminQuotes.isEmpty ? candidates : adminQuotes;
  }

  List<Quote> _candidateQuotes(List<Quote> all, UserProfile profile) {
    if (profile.quoteDiscoveryMode != QuoteDiscoveryMode.manual) {
      return all;
    }

    if (profile.selectedSources.isEmpty) {
      return all;
    }

    final selected = profile.selectedSources
        .map((String value) => value.toLowerCase())
        .toSet();

    return all
        .where((Quote quote) => selected.contains(quote.source.toLowerCase()))
        .toList();
  }

  bool _isAdminQuote(Quote quote) {
    final source = quote.source.toLowerCase();
    return source.contains('marx') || source.contains('engels');
  }

  int _issueNumberFor(DateTime now) {
    final epoch = DateTime(2000, 1, 1);
    return now.difference(epoch).inDays;
  }
}
