import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/history_fact.dart';
import '../../data/models/quote.dart';
import '../../data/models/user_profile.dart';
import '../services/personalization_service.dart';
import 'repository_providers.dart';
import 'user_profile_provider.dart';

enum ArchiveTab { all, history }

class ArchiveItem {
  const ArchiveItem.quote(this.quote) : fact = null;
  const ArchiveItem.fact(this.fact) : quote = null;

  final Quote? quote;
  final HistoryFact? fact;

  bool get isQuote => quote != null;
  bool get isFact => fact != null;
}

final personalizationServiceProvider = Provider<PersonalizationService>((
  Ref ref,
) {
  return PersonalizationService();
});

final archiveQueryProvider = StateProvider<String>((Ref ref) => '');
final archiveTabProvider = StateProvider<ArchiveTab>(
  (Ref ref) => ArchiveTab.all,
);
final archiveThemeFilterProvider = StateProvider<String?>((Ref ref) => null);
final archiveOrientationFilterProvider = StateProvider<String?>(
  (Ref ref) => null,
);

final archivePoolProvider = StreamProvider<List<ArchiveItem>>((Ref ref) async* {
  await ref.watch(initialSeedProvider.future);

  final query = ref.watch(archiveQueryProvider).trim().toLowerCase();
  final tab = ref.watch(archiveTabProvider);
  final selectedTheme = ref.watch(archiveThemeFilterProvider);
  final selectedOrientation = ref.watch(archiveOrientationFilterProvider);
  final profile = ref.watch(userProfileProvider);
  final personalization = ref.watch(personalizationServiceProvider);
  // History facts are intentionally not loaded here because they are
  // temporarily excluded from the archive listing.

  yield* ref.watch(quoteRepositoryProvider).watchAllQuotes().map((
    List<Quote> quotes,
  ) {
    // Filter quotes based on user profile
    final profileQuotes = _filterQuotesByProfile(quotes, profile);
    // Weight quotes based on personalization
    final weightedQuotes = personalization.getWeightedQuotes(
      profileQuotes,
      profile,
    );
    // Weight facts based on personalization (currently unused because
    // history facts are temporarily excluded from the archive listing).

    // Temporarily exclude history facts from the archive listing per UX request.
    // Keep quotes only for now; facts (from assets/history_facts.json) are
    // intentionally hidden while we review them.
    final items = <ArchiveItem>[
      ...weightedQuotes.map(ArchiveItem.quote),
      // ...weightedFacts.map(ArchiveItem.fact),
    ];

    final tabFiltered = items.where((ArchiveItem item) {
      switch (tab) {
        case ArchiveTab.all:
          return true;
        case ArchiveTab.history:
          return item.isFact;
      }
    }).toList();

    final dropdownFiltered = tabFiltered.where((ArchiveItem item) {
      if (selectedTheme != null &&
          !_matchesTheme(item: item, theme: selectedTheme)) {
        return false;
      }

      if (selectedOrientation != null &&
          !_matchesOrientation(item: item, orientation: selectedOrientation)) {
        return false;
      }

      return true;
    }).toList();

    if (query.isEmpty) {
      return dropdownFiltered;
    }

    return dropdownFiltered.where((ArchiveItem item) {
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

final archiveThemeFilterOptionsProvider = Provider<List<String>>((Ref ref) {
  final pool = ref.watch(archivePoolProvider).valueOrNull ?? <ArchiveItem>[];
  final options = <String>{};

  for (final item in pool) {
    options.addAll(_themeTokensForItem(item: item));
  }

  final sorted = options.toList()..sort();
  return sorted;
});

final archiveOrientationFilterOptionsProvider = Provider<List<String>>((
  Ref ref,
) {
  final pool = ref.watch(archivePoolProvider).valueOrNull ?? <ArchiveItem>[];
  final options = <String>{};

  for (final item in pool) {
    options.addAll(_orientationTokensForItem(item: item));
  }

  final sorted = options.toList()..sort();
  return sorted.take(8).toList();
});

final archiveProvider = Provider<AsyncValue<List<ArchiveItem>>>((Ref ref) {
  final poolAsync = ref.watch(archivePoolProvider);

  return poolAsync;
});

Set<String> _themeTokensForItem({required ArchiveItem item}) {
  if (item.isQuote) {
    final quote = item.quote!;
    return <String>{...quote.category};
  }

  final fact = item.fact!;
  return <String>{...fact.category};
}

Set<String> _orientationTokensForItem({required ArchiveItem item}) {
  final text = item.isQuote
      ? <String>[
          item.quote!.textDe,
          item.quote!.source,
          item.quote!.chapter,
          ...item.quote!.category,
        ].join(' ').toLowerCase()
      : <String>[
          item.fact!.headline,
          item.fact!.body,
          item.fact!.era,
          item.fact!.region,
          item.fact!.connectionToMarx,
          if (item.fact!.person != null) item.fact!.person!,
          if (item.fact!.personRole != null) item.fact!.personRole!,
          ...item.fact!.category,
        ].join(' ').toLowerCase();

  final tokens = <String>{};

  if (_containsAny(text, <String>[
    'arbeit',
    'klasse',
    'revolution',
    'solidar',
    'gewerkschaft',
    'umverteilung',
    'sozial',
  ])) {
    tokens.add('Links');
  }

  if (_containsAny(text, <String>[
    'demokratie',
    'gerecht',
    'reform',
    'teilhabe',
    'chancen',
    'gleichheit',
  ])) {
    tokens.add('Mitte-Links');
  }

  if (_containsAny(text, <String>[
    'freiheit',
    'rechte',
    'individ',
    'aufklärung',
    'markt',
    'plural',
  ])) {
    tokens.add('Liberal');
  }

  if (_containsAny(text, <String>[
    'ordnung',
    'staat',
    'tradition',
    'familie',
    'sicherheit',
    'werte',
  ])) {
    tokens.add('Konservativ');
  }

  if (tokens.isEmpty) {
    tokens.add('Neutral');
  }

  return tokens;
}

bool _containsAny(String text, List<String> keywords) {
  return keywords.any((String keyword) => text.contains(keyword));
}

bool _matchesTheme({required ArchiveItem item, required String theme}) {
  final normalized = theme.toLowerCase();
  if (item.isQuote) {
    return item.quote!.category.any(
      (String category) => category.toLowerCase().contains(normalized),
    );
  }

  return item.fact!.category.any(
    (String category) => category.toLowerCase().contains(normalized),
  );
}

bool _matchesOrientation({
  required ArchiveItem item,
  required String orientation,
}) {
  return _orientationTokensForItem(item: item).contains(orientation);
}

List<Quote> _filterQuotesByProfile(List<Quote> all, UserProfile profile) {
  return all;
}
