import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/history_fact.dart';
import '../../data/models/quote.dart';
import 'repository_providers.dart';

enum ArchiveTab { all, marx, history }

class ArchiveItem {
  const ArchiveItem.quote(this.quote) : fact = null;
  const ArchiveItem.fact(this.fact) : quote = null;

  final Quote? quote;
  final HistoryFact? fact;

  bool get isQuote => quote != null;
  bool get isFact => fact != null;
}

final archiveQueryProvider = StateProvider<String>((Ref ref) => '');
final archiveTabProvider = StateProvider<ArchiveTab>(
  (Ref ref) => ArchiveTab.all,
);
final archiveActiveFiltersProvider = StateProvider<Set<String>>(
  (Ref ref) => <String>{},
);

final archivePoolProvider = StreamProvider<List<ArchiveItem>>((Ref ref) async* {
  await ref.watch(initialSeedProvider.future);

  final query = ref.watch(archiveQueryProvider).trim().toLowerCase();
  final tab = ref.watch(archiveTabProvider);
  final historyRepository = ref.watch(historyRepositoryProvider);
  final facts = await historyRepository.watchAllHistoryFacts().first;

  yield* ref.watch(quoteRepositoryProvider).watchAllQuotes().map((
    List<Quote> quotes,
  ) {
    final items = <ArchiveItem>[
      ...quotes.map(ArchiveItem.quote),
      ...facts.map(ArchiveItem.fact),
    ];

    final tabFiltered = items.where((ArchiveItem item) {
      switch (tab) {
        case ArchiveTab.all:
          return true;
        case ArchiveTab.marx:
          return item.isQuote;
        case ArchiveTab.history:
          return item.isFact;
      }
    }).toList();

    if (query.isEmpty) {
      return tabFiltered;
    }

    return tabFiltered.where((ArchiveItem item) {
      if (item.isQuote) {
        final quote = item.quote!;
        return quote.textDe.toLowerCase().contains(query) ||
            quote.source.toLowerCase().contains(query) ||
            quote.series.toLowerCase().contains(query) ||
            quote.category.any(
              (String category) => category.toLowerCase().contains(query),
            );
      }

      final fact = item.fact!;
      return fact.headline.toLowerCase().contains(query) ||
          fact.body.toLowerCase().contains(query) ||
          fact.region.toLowerCase().contains(query) ||
          fact.era.toLowerCase().contains(query) ||
          fact.category.any(
            (String category) => category.toLowerCase().contains(query),
          ) ||
          (fact.person?.toLowerCase().contains(query) ?? false);
    }).toList();
  });
});

final archiveFilterOptionsProvider = Provider<List<String>>((Ref ref) {
  final pool = ref.watch(archivePoolProvider).valueOrNull ?? <ArchiveItem>[];
  final tab = ref.watch(archiveTabProvider);
  final options = <String>{};

  for (final item in pool) {
    options.addAll(_tokensForTab(item: item, tab: tab));
  }

  final sorted = options.toList()..sort();
  return sorted.take(24).toList();
});

final archiveProvider = Provider<AsyncValue<List<ArchiveItem>>>((Ref ref) {
  final activeFilters = ref.watch(archiveActiveFiltersProvider);
  final tab = ref.watch(archiveTabProvider);
  final poolAsync = ref.watch(archivePoolProvider);

  return poolAsync.whenData((List<ArchiveItem> items) {
    if (activeFilters.isEmpty) {
      return items;
    }

    return items.where((ArchiveItem item) {
      final tokens = _tokensForTab(item: item, tab: tab);
      return activeFilters.any(tokens.contains);
    }).toList();
  });
});

Set<String> _tokensForTab({
  required ArchiveItem item,
  required ArchiveTab tab,
}) {
  if (item.isQuote) {
    final quote = item.quote!;
    if (tab == ArchiveTab.history) {
      return <String>{};
    }
    return <String>{quote.source, quote.difficulty, ...quote.category, 'ZITAT'};
  }

  final fact = item.fact!;
  if (tab == ArchiveTab.marx) {
    return <String>{};
  }
  return <String>{
    fact.era,
    fact.region,
    fact.difficulty,
    ...fact.category,
    if ((fact.person ?? '').trim().isNotEmpty) fact.person!,
    'FAKT',
  };
}
