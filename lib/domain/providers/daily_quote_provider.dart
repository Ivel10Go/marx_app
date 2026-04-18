import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/quote.dart';
import 'repository_providers.dart';

final dailyQuoteProvider = FutureProvider<Quote?>((Ref ref) async {
  await ref.watch(initialSeedProvider.future);
  return ref.watch(quoteRepositoryProvider).getDailyQuote();
});

final quoteByIdProvider = FutureProvider.family<Quote?, String>((
  Ref ref,
  String id,
) async {
  await ref.watch(initialSeedProvider.future);
  return ref.watch(quoteRepositoryProvider).getQuoteById(id);
});
