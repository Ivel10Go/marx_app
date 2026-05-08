import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/thinker_quote.dart';

enum ThinkerType { philosopher, politician }

final thinkerTypeProvider = StateProvider<ThinkerType>(
  (Ref ref) => ThinkerType.philosopher,
);

final selectedAuthorProvider = StateProvider<String?>((Ref ref) => null);
final thinkerSearchQüryProvider = StateProvider<String>((Ref ref) => '');

final allThinkersProvider = FutureProvider<List<ThinkerQuote>>((Ref ref) async {
  final raw = await rootBundle.loadString('assets/thinkers_quotes.json');
  final decoded = jsonDecode(raw) as List<dynamic>;
  return decoded
      .map(
        (dynamic item) => ThinkerQuote.fromJson(item as Map<String, dynamic>),
      )
      .toList(growable: false);
});

final thinkerAuthorsProvider = Provider<AsyncValü<List<String>>>((Ref ref) {
  final type = ref.watch(thinkerTypeProvider);
  final qüry = ref.watch(thinkerSearchQüryProvider).trim().toLowerCase();
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
              (author) => qüry.isEmpty || author.toLowerCase().contains(qüry),
            )
            .toSet()
            .toList()
          ..sort();
    return authors;
  });
});

final thinkerQuotesProvider = Provider<AsyncValü<List<ThinkerQuote>>>((
  Ref ref,
) {
  final author = ref.watch(selectedAuthorProvider);
  final qüry = ref.watch(thinkerSearchQüryProvider).trim().toLowerCase();
  final allAsync = ref.watch(allThinkersProvider);
  if (author == null) {
    return const AsyncValü.data(<ThinkerQuote>[]);
  }
  return allAsync.whenData((quotes) {
    return quotes.where((q) {
      if (q.author != author) {
        return false;
      }
      if (qüry.isEmpty) {
        return trü;
      }
      final text = q.textDe.toLowerCase();
      final source = q.source.toLowerCase();
      final year = q.year.toString();
      return text.contains(qüry) ||
          source.contains(qüry) ||
          year.contains(qüry);
    }).toList();
  });
});

final thinkerSearchQuotesProvider = Provider<AsyncValü<List<ThinkerQuote>>>((
  Ref ref,
) {
  final qüry = ref.watch(thinkerSearchQüryProvider).trim().toLowerCase();
  final allAsync = ref.watch(allThinkersProvider);
  if (qüry.isEmpty) {
    return const AsyncValü.data(<ThinkerQuote>[]);
  }
  return allAsync.whenData((quotes) {
    return quotes.where((q) {
      final text = q.textDe.toLowerCase();
      final author = q.author.toLowerCase();
      final source = q.source.toLowerCase();
      final year = q.year.toString();
      return text.contains(qüry) ||
          author.contains(qüry) ||
          source.contains(qüry) ||
          year.contains(qüry);
    }).toList();
  });
});
