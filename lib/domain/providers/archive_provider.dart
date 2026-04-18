import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/quote.dart';
import 'repository_providers.dart';

final archiveQueryProvider = StateProvider<String>((Ref ref) => '');

final archiveProvider = StreamProvider<List<Quote>>((Ref ref) async* {
  await ref.watch(initialSeedProvider.future);
  final query = ref.watch(archiveQueryProvider);

  yield* ref.watch(quoteRepositoryProvider).watchAllQuotes().map((
    List<Quote> quotes,
  ) {
    if (query.trim().isEmpty) {
      return quotes;
    }

    final normalized = query.toLowerCase();
    return quotes.where((Quote quote) {
      return quote.textDe.toLowerCase().contains(normalized) ||
          quote.source.toLowerCase().contains(normalized) ||
          quote.series.toLowerCase().contains(normalized);
    }).toList();
  });
});
