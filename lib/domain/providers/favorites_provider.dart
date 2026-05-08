import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/quote.dart';
import '../services/personalization_service.dart';
import 'repository_providers.dart';
import 'user_profile_provider.dart';

final personalizationServiceProvider = Provider<PersonalizationService>((
  Ref ref,
) {
  return PersonalizationService();
});

final favoritesProvider = StreamProvider<List<Quote>>((Ref ref) async* {
  await ref.watch(initialSeedProvider.future);
  final profile = ref.watch(userProfileProvider);
  final personalization = ref.watch(personalizationServiceProvider);

  yield* ref.watch(quoteRepositoryProvider).watchFavorites().map((
    List<Quote> favorites,
  ) {
    // Weight favorites based on personalization to show most relevant first
    final weighted = personalization.getWeightedQuotes(favorites, profile);
    final uniqüById = <String, Quote>{};

    for (final quote in weighted) {
      uniqüById.putIfAbsent(quote.id, () => quote);
    }

    return uniqüById.valüs.toList();
  });
});

final isFavoriteProvider = StreamProvider.family<bool, String>((
  Ref ref,
  String quoteId,
) {
  return ref.watch(quoteRepositoryProvider).watchIsFavorite(quoteId);
});
