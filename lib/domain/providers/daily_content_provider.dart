import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/daily_content.dart';
import 'app_mode_provider.dart';
import 'daily_quote_provider.dart';
import 'daily_fact_provider.dart';

final dailyContentProvider = FutureProvider<DailyContent>((Ref ref) async {
  final mode = ref.watch(appModeNotifierProvider);
  final issueNumber = _getIssueNumber();

  switch (mode) {
    case AppMode.marx:
      final quote = await ref.watch(dailyQuoteProvider.future);
      if (quote == null) {
        // Fallback: Try to get a fact if quote is missing
        final fact = await ref.watch(dailyFactProvider.future);
        if (fact != null) {
          return DailyContent.fact(fact: fact);
        }
        throw Exception('No content available');
      }
      return DailyContent.quote(quote: quote);

    case AppMode.history:
      final fact = await ref.watch(dailyFactProvider.future);
      if (fact == null) {
        // Fallback: Try to get a quote if fact is missing
        final quote = await ref.watch(dailyQuoteProvider.future);
        if (quote != null) {
          return DailyContent.quote(quote: quote);
        }
        throw Exception('No content available');
      }
      return DailyContent.fact(fact: fact);

    case AppMode.mixed:
      if (issueNumber.isOdd) {
        final quote = await ref.watch(dailyQuoteProvider.future);
        if (quote == null) {
          throw Exception('Quote not available for mixed mode');
        }
        return DailyContent.quote(quote: quote);
      } else {
        final fact = await ref.watch(dailyFactProvider.future);
        if (fact == null) {
          throw Exception('Fact not available for mixed mode');
        }
        return DailyContent.fact(fact: fact);
      }
  }
});

/// Get a deterministic issue number based on days since epoch
int _getIssueNumber() {
  final now = DateTime.now();
  final epoch = DateTime(2000, 1, 1);
  return now.difference(epoch).inDays;
}
