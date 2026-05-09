import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/thinker_quote.dart';

enum ThinkerType { philosopher, politician }

final thinkerTypeProvider = StateProvider<ThinkerType>(
  (Ref ref) => ThinkerType.philosopher,
);

final selectedAuthorProvider = StateProvider<String?>((Ref ref) => null);
final thinkerSearchQueryProvider = StateProvider<String>((Ref ref) => '');

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
  final query = ref.watch(thinkerSearchQueryProvider).trim().toLowerCase();
  final allAsync = ref.watch(allThinkersProvider);
  return allAsync.whenData((quotes) {
    final typeStr = type == ThinkerType.philosopher
        ? 'philosopher'
        : 'politician';
    final authors =
        quotes
            .where((q) => q.authorType == typeStr)
            .map((q) => q.author)
            .where(
              (author) => query.isEmpty || author.toLowerCase().contains(query),
            )
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
  final query = ref.watch(thinkerSearchQueryProvider).trim().toLowerCase();
  final allAsync = ref.watch(allThinkersProvider);
  if (author == null) {
    return const AsyncValue.data(<ThinkerQuote>[]);
  }
  return allAsync.whenData((quotes) {
    return quotes.where((q) {
      if (q.author != author) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      final text = q.textDe.toLowerCase();
      final source = q.source.toLowerCase();
      final year = q.year.toString();
      return text.contains(query) ||
          source.contains(query) ||
          year.contains(query);
    }).toList();
  });
});

final thinkerSearchQuotesProvider = Provider<AsyncValue<List<ThinkerQuote>>>((
  Ref ref,
) {
  final query = ref.watch(thinkerSearchQueryProvider).trim().toLowerCase();
  final allAsync = ref.watch(allThinkersProvider);
  if (query.isEmpty) {
    return const AsyncValue.data(<ThinkerQuote>[]);
  }
  return allAsync.whenData((quotes) {
    return quotes.where((q) {
      final text = q.textDe.toLowerCase();
      final author = q.author.toLowerCase();
      final source = q.source.toLowerCase();
      final year = q.year.toString();
      return text.contains(query) ||
          author.contains(query) ||
          source.contains(query) ||
          year.contains(query);
    }).toList();
  });
});
