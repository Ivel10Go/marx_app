import 'dart:math';

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

    if (_hasInterestOverlap(quote.category, profile.historicalInterests)) {
      score += 0.5;
    }

    switch (profile.politicalLeaning) {
      case PoliticalLeaning.left:
        if (_matchesAny(
          quote,
          <String>['kapital', 'manifest', 'feuerbach'],
          <String>[
            'kapital',
            'manifest',
            'feuerbach',
            'klassenkampf',
            'arbeit',
          ],
        )) {
          score += 0.75;
        }
      case PoliticalLeaning.centerLeft:
        if (_matchesAny(
          quote,
          <String>['manifest', 'kapital'],
          <String>['arbeit', 'gewerkschaft', 'demokratie'],
        )) {
          score += 0.45;
        }
      case PoliticalLeaning.neutral:
        break;
      case PoliticalLeaning.liberal:
        if (_matchesAny(
          quote,
          <String>['feuerbach', 'misc'],
          <String>['freiheit', 'aufklaerung', 'rechte', 'buerger'],
        )) {
          score += 0.6;
        }
      case PoliticalLeaning.conservative:
        if (_matchesAny(
          quote,
          <String>['misc', 'brumaire'],
          <String>['ordnung', 'staat', 'tradition'],
        )) {
          score += 0.45;
        }
    }

    return score;
  }

  double _factWeight(HistoryFact fact, UserProfile profile) {
    var score = 1.0;

    if (_hasInterestOverlap(fact.category, profile.historicalInterests)) {
      score += 0.5;
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
          'aufklaerung',
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

  bool _hasInterestOverlap(List<String> categories, List<String> interests) {
    if (interests.isEmpty) {
      return false;
    }

    final normalizedInterests = interests
        .map((String value) => value.toLowerCase())
        .toSet();

    return categories.any((String category) {
      final normalizedCategory = category.toLowerCase();
      return normalizedInterests.any(
        (String interest) => normalizedCategory.contains(interest),
      );
    });
  }

  bool _matchesAny(Quote quote, List<String> series, List<String> keywords) {
    final haystack = <String>[
      quote.series,
      quote.source,
      quote.chapter,
      ...quote.category,
    ].join(' ').toLowerCase();

    final matchSeries = series.any(
      (String value) => quote.series.toLowerCase().contains(value),
    );
    final matchKeyword = keywords.any(
      (String value) => haystack.contains(value),
    );
    return matchSeries || matchKeyword;
  }

  bool _containsAny(List<String> values, List<String> keywords) {
    final text = values.join(' ').toLowerCase();
    return keywords.any((String keyword) => text.contains(keyword));
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
