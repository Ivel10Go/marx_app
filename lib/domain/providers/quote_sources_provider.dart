import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repository_providers.dart';

final availableQuoteSourcesProvider = FutureProvider<List<String>>((
  Ref ref,
) async {
  await ref.watch(initialSeedProvider.future);
  final quotes = await ref
      .watch(quoteRepositoryProvider)
      .watchAllQuotes()
      .first;
  final sources =
      quotes
          .map((quote) => quote.source.trim())
          .where((source) => source.isNotEmpty)
          .toSet()
          .toList()
        ..sort();
  return sources;
});
