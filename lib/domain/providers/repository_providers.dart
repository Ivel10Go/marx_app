import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // Check if seeding was already done (idempotent check via SharedPreferences)
  final prefs = await SharedPreferences.getInstance();
  const seedKey = 'app_seeded_v1';

  if (prefs.getBool(seedKey) == true) {
    // Already seeded, skip
    return;
  }

  // Mark as seeding to prevent concurrent operations
  await prefs.setBool(seedKey, true);

  try {
    await ref.watch(quoteRepositoryProvider).ensureSeeded();
    await ref.watch(historyRepositoryProvider).ensureSeeded();
  } catch (e) {
    // Reset flag on error so retry can happen
    await prefs.remove(seedKey);
    rethrow;
  }
});
