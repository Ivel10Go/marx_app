import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/quote.dart';
import 'repository_providers.dart';

final favoritesProvider = StreamProvider<List<Quote>>((Ref ref) async* {
  await ref.watch(initialSeedProvider.future);
  yield* ref.watch(quoteRepositoryProvider).watchFavorites();
});

final isFavoriteProvider = StreamProvider.family<bool, String>((
  Ref ref,
  String quoteId,
) {
  return ref.watch(quoteRepositoryProvider).watchIsFavorite(quoteId);
});
