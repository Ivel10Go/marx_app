import 'package:flutter/foundation.dart';

import '../../data/models/quote.dart';

/// Berechnet die Levenshtein-Distanz zwischen zwei Strings
int _levenshteinDistance(String s1, String s2) {
  final len1 = s1.length;
  final len2 = s2.length;

  final d = List<List<int>>.generate(
    len1 + 1,
    (i) => List<int>.generate(len2 + 1, (j) => 0),
  );

  for (var i = 0; i <= len1; i++) {
    d[i][0] = i;
  }
  for (var j = 0; j <= len2; j++) {
    d[0][j] = j;
  }

  for (var i = 1; i <= len1; i++) {
    for (var j = 1; j <= len2; j++) {
      final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
      d[i][j] = [
        d[i - 1][j] + 1,
        d[i][j - 1] + 1,
        d[i - 1][j - 1] + cost,
      ].reduce((a, b) => a < b ? a : b);
    }
  }

  return d[len1][len2];
}

/// Berechnet Ähnlichkeitsquote (0.0 - 1.0) basierend auf Levenshtein-Distanz
double _calculateSimilarity(String s1, String s2) {
  final maxLen = [s1.length, s2.length].reduce((a, b) => a > b ? a : b);
  if (maxLen == 0) return 1.0;

  final distance = _levenshteinDistance(s1, s2);
  return 1.0 - (distance / maxLen);
}

/// Normalisierttext für Vergleiche (lowercase, trimmen, Sonderzeichen entfernen)
String _normalizeText(String text) {
  return text
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[^a-zäöüß0-9\s]'), '')
      .replaceAll(RegExp(r'\s+'), ' ');
}

/// Service zur Erkennung von duplizierten oder ähnlichen Zitaten
abstract final class QuoteDeduplicationService {
  /// Findet ähnliche Zitate im Katalog
  ///
  /// Gibt eine Liste von Zitaten zurück, die ≥ threshold Ähnlichkeit haben.
  /// Der Threshold kann von 0.0 (völlig unterschiedlich) bis 1.0 (identisch) sein.
  /// Standard: 0.75 (75% Ähnlichkeit)
  static List<Quote> findSimilarQuotes(
    String newQuoteText,
    List<Quote> existingQuotes, {
    double threshold = 0.75,
  }) {
    if (newQuoteText.isEmpty || existingQuotes.isEmpty) {
      return <Quote>[];
    }

    final normalized = _normalizeText(newQuoteText);

    final results = <Quote>[];

    for (final quote in existingQuotes) {
      final existingNormalized = _normalizeText(quote.textDe);
      final similarity = _calculateSimilarity(normalized, existingNormalized);

      debugPrint(
        '[QuoteDedupService] Comparing "$newQuoteText" '
        'with "${quote.textDe}" → similarity: ${(similarity * 100).toStringAsFixed(1)}%',
      );

      if (similarity >= threshold) {
        results.add(quote);
      }
    }

    return results;
  }

  /// Prüft ob ein Zitat wahrscheinlich ein Duplikat ist (mit striktem Threshold)
  static bool isProbableDuplicate(
    String newQuoteText,
    List<Quote> existingQuotes, {
    double strictThreshold = 0.85,
  }) {
    return findSimilarQuotes(
      newQuoteText,
      existingQuotes,
      threshold: strictThreshold,
    ).isNotEmpty;
  }
}
