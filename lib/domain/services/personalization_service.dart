import 'dart:math';

import '../../core/utils/german_text_normalizer.dart';
import '../../data/models/history_fact.dart';
import '../../data/models/quote.dart';
import '../../data/models/user_profile.dart';

class PersonalizationService {
  List<Quote> getWeightedQuotes(List<Quote> all, UserProfile profile) {
    if (all.isEmpty) {
      return all;
    }

    return _expandByWeight<Quote>(
      all,
      (Quote quote) => _quoteWeight(quote, profile),
    );
  }

  List<HistoryFact> getWeightedFacts(
    List<HistoryFact> all,
    UserProfile profile,
  ) {
    if (all.isEmpty) {
      return all;
    }

    return _expandByWeight<HistoryFact>(
      all,
      (HistoryFact fact) => _factWeight(fact, profile),
    );
  }

  double _quoteWeight(Quote quote, UserProfile profile) {
    var score = 1.0;

    final quoteContext = <String>[
      quote.series,
      quote.source,
      quote.chapter,
      ...quote.category,
      quote.textDe,
    ].join(' ').toLowerCase();

    if (anyInterestMatchesText(
      interests: profile.historicalInterests,
      texts: <String>[quoteContext],
    )) {
      score += 1.5;
    }

    switch (profile.politicalLeaning) {
      case PoliticalLeaning.left:
        if (_containsAnyInText(quoteContext, <String>[
          'arbeit',
          'revolution',
          'ungleichheit',
          'solidar',
          'gewerkschaft',
          'umverteilung',
          'klasse',
        ])) {
          score += 1.0;
        }
      case PoliticalLeaning.centerLeft:
        if (_containsAnyInText(quoteContext, <String>[
          'sozial',
          'gerecht',
          'demokratie',
          'chancen',
          'arbeit',
          'teilhabe',
          'reform',
        ])) {
          score += 0.8;
        }
      case PoliticalLeaning.neutral:
        break;
      case PoliticalLeaning.liberal:
        if (_containsAnyInText(quoteContext, <String>[
          'freiheit',
          'rechte',
          'individ',
          'markt',
          'aufklärung',
          'plural',
          'eigenverantwort',
        ])) {
          score += 1.0;
        }
      case PoliticalLeaning.conservative:
        if (_containsAnyInText(quoteContext, <String>[
          'ordnung',
          'staat',
          'tradition',
          'sicherheit',
          'familie',
          'werte',
          'kontinuit',
        ])) {
          score += 1.0;
        }
    }

    return score;
  }

  double _factWeight(HistoryFact fact, UserProfile profile) {
    var score = 1.0;

    final factContext = <String>[
      fact.headline,
      fact.body,
      fact.region,
      fact.era,
      fact.connectionToMarx,
      if (fact.person != null) fact.person!,
      if (fact.personRole != null) fact.personRole!,
      ...fact.category,
    ].join(' ');

    if (anyInterestMatchesText(
      interests: profile.historicalInterests,
      texts: <String>[factContext],
    )) {
      score += 1.5;
    }

    switch (profile.politicalLeaning) {
      case PoliticalLeaning.left:
        if (_containsAny(fact.category, <String>[
          'arbeit',
          'revolution',
          'gewerkschaft',
          'kommune',
        ])) {
          score += 0.65;
        }
      case PoliticalLeaning.centerLeft:
        if (_containsAny(fact.category, <String>[
          'arbeit',
          'demokratie',
          'reform',
          'gewerkschaft',
        ])) {
          score += 0.45;
        }
      case PoliticalLeaning.neutral:
        break;
      case PoliticalLeaning.liberal:
        if (_containsAny(fact.category, <String>[
          'freiheit',
          'rechte',
          'aufklärung',
          'verfassung',
        ])) {
          score += 0.6;
        }
      case PoliticalLeaning.conservative:
        if (_containsAny(fact.category, <String>[
          'staat',
          'ordnung',
          'kirche',
          'tradition',
        ])) {
          score += 0.45;
        }
    }

    return score;
  }

  bool _containsAny(List<String> values, List<String> keywords) {
    final text = normalizeGermanSearchText(values.join(' '));
    return keywords.any((String keyword) => text.contains(keyword));
  }

  bool _containsAnyInText(String text, List<String> keywords) {
    final normalizedText = normalizeGermanSearchText(text);
    return keywords.any(
      (String keyword) =>
          normalizedText.contains(normalizeGermanSearchText(keyword)),
    );
  }

  List<T> _expandByWeight<T>(List<T> values, double Function(T item) scoreFor) {
    final weighted = <T>[];

    for (final item in values) {
      final score = scoreFor(item);
      final multiplier = max(1, (score * 10).round());
      for (var i = 0; i < multiplier; i++) {
        weighted.add(item);
      }
    }

    return weighted;
  }
}
