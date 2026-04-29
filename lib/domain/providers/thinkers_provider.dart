import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/thinker_quote.dart';

enum ThinkerType { philosopher, politician }

final thinkerTypeProvider = StateProvider<ThinkerType>(
  (Ref ref) => ThinkerType.philosopher,
);

final selectedAuthorProvider = StateProvider<String?>((Ref ref) => null);

final allThinkersProvider = FutureProvider<List<ThinkerQuote>>((Ref ref) async {
  final raw = await rootBundle.loadString('assets/thinkers_quotes.json');
  final decoded = jsonDecode(raw) as List<dynamic>;
  return decoded
      .map(
        (dynamic item) => ThinkerQuote.fromJson(item as Map<String, dynamic>),
      )
      .toList(growable: false);
});

final thinkerAuthorsProvider = Provider<AsyncValue<List<String>>>((Ref ref) {
  final type = ref.watch(thinkerTypeProvider);
  final allAsync = ref.watch(allThinkersProvider);
  return allAsync.whenData((quotes) {
    final typeStr = type == ThinkerType.philosopher
        ? 'philosopher'
        : 'politician';
    final authors =
        quotes
            .where((q) => q.authorType == typeStr)
            .map((q) => q.author)
            .toSet()
            .toList()
          ..sort();
    return authors;
  });
});

final thinkerQuotesProvider = Provider<AsyncValue<List<ThinkerQuote>>>((
  Ref ref,
) {
  final author = ref.watch(selectedAuthorProvider);
  final allAsync = ref.watch(allThinkersProvider);
  if (author == null) {
    return const AsyncValue.data(<ThinkerQuote>[]);
  }
  return allAsync.whenData(
    (quotes) => quotes.where((q) => q.author == author).toList(),
  );
});
