import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../../data/models/daily_content.dart';
import '../../data/models/history_fact.dart';
import '../../data/models/quote.dart';
import '../../data/models/thinker_quote.dart';
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

final allThinkerQuotesRawProvider = FutureProvider<List<ThinkerQuote>>((
  Ref ref,
) async {
  final raw = await rootBundle.loadString('assets/thinkers_quotes.json');
  final decoded = jsonDecode(raw) as List<dynamic>;
  return decoded
      .map((dynamic item) => ThinkerQuote.fromJson(item as Map<String, dynamic>))
      .toList();
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

    case AppMode.godmode:
      // Only Marx & Engels quotes, preferring hard/medium difficulty
      final marxQuotes = allQuotes.where((q) {
        final src = q.source.toLowerCase();
        return src.contains('marx') ||
            src.contains('engels') ||
            src.contains('kapital') ||
            src.contains('manifest') ||
            q.series.isNotEmpty;
      }).toList();
      final pool = marxQuotes.isNotEmpty ? marxQuotes : allQuotes;
      // Weight hard/medium higher
      final godmodeWeighted = <Quote>[];
      for (final q in pool) {
        final multiplier = q.difficulty == 'hard'
            ? 3
            : q.difficulty == 'medium'
            ? 2
            : 1;
        for (var i = 0; i < multiplier; i++) {
          godmodeWeighted.add(q);
        }
      }
      if (godmodeWeighted.isEmpty) {
        throw Exception('No content available for GODMODE');
      }
      final rng = Random(issueNumber + 42);
      return DailyContent.quote(
        quote: godmodeWeighted[rng.nextInt(godmodeWeighted.length)],
      );

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
      // 3-cycle: 0=quote, 1=fact, 2=thinkerQuote
      final cycle = issueNumber % 3;
      if (cycle == 0) {
        final quote = _pickWeightedQuote(
          allQuotes,
          profile,
          issueNumber,
          personalization,
        );
        if (quote == null) throw Exception('Quote not available for mixed mode');
        return DailyContent.quote(quote: quote);
      } else if (cycle == 1) {
        final fact = _pickWeightedFact(
          allFacts,
          profile,
          issueNumber,
          personalization,
        );
        if (fact == null) throw Exception('Fact not available for mixed mode');
        return DailyContent.fact(fact: fact);
      } else {
        final allThinkers = await ref.watch(
          allThinkerQuotesRawProvider.future,
        );
        if (allThinkers.isEmpty) {
          throw Exception('Thinker quotes not available for mixed mode');
        }
        final rng = Random(issueNumber + 77);
        final tq = allThinkers[rng.nextInt(allThinkers.length)];
        return DailyContent.thinkerQuote(thinkerQuote: tq);
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
