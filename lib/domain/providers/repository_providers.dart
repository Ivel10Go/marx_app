import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/quote_repository.dart';
import '../../data/repositories/history_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final quoteRepositoryProvider = Provider<QuoteRepository>((Ref ref) {
  return QuoteRepository(ref.watch(appDatabaseProvider));
});

final historyRepositoryProvider = Provider<HistoryRepository>((Ref ref) {
  return HistoryRepository(ref.watch(appDatabaseProvider));
});

final initialSeedProvider = FutureProvider<void>((Ref ref) async {
  await ref.watch(quoteRepositoryProvider).ensureSeeded();
  await ref.watch(historyRepositoryProvider).ensureSeeded();
});
