import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/history_fact.dart';
import 'repository_providers.dart';

final dailyFactProvider = FutureProvider<HistoryFact?>((Ref ref) async {
  final historyRepository = ref.watch(historyRepositoryProvider);
  return historyRepository.getDailyHistoryFact();
});
