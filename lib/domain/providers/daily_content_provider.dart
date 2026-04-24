import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import '../../data/models/daily_content.dart';
import '../../data/models/quote.dart';
import '../../data/models/user_profile.dart';
import '../services/personalization_service.dart';
import 'repository_providers.dart';
import 'user_profile_provider.dart';

final personalizationServiceProvider = Provider<PersonalizationService>((
  Ref ref,
) {
  return PersonalizationService();
});

final dailyContentProvider = FutureProvider<DailyContent>((Ref ref) async {
  await ref.watch(initialSeedProvider.future);
  final profile = ref.watch(userProfileProvider);
  final quoteRepository = ref.watch(quoteRepositoryProvider);
  final personalization = ref.watch(personalizationServiceProvider);
  final issueNumber = _getIssueNumber();

  final allQuotes = await quoteRepository.watchAllQuotes().first;

  final candidates = _candidateQuotes(allQuotes, profile);
  final quote = _pickWeightedQuote(
    candidates.isEmpty ? allQuotes : candidates,
    profile,
    issueNumber,
    personalization,
  );

  if (quote == null) {
    throw Exception('No quote content available');
  }

  return DailyContent.quote(quote: quote);
});

List<Quote> _candidateQuotes(List<Quote> all, UserProfile profile) {
  if (profile.quoteDiscoveryMode != QuoteDiscoveryMode.manual) {
    return all;
  }

  if (profile.selectedSources.isEmpty) {
    return all;
  }

  final selected = profile.selectedSources
      .map((value) => value.toLowerCase())
      .toSet();
  return all
      .where((quote) => selected.contains(quote.source.toLowerCase()))
      .toList();
}

Quote? _pickWeightedQuote(
  List<Quote> all,
  UserProfile profile,
  int issueNumber,
  PersonalizationService personalization,
) {
  if (all.isEmpty) {
    return null;
  }
  final weighted = personalization.getWeightedQuotes(all, profile);
  final random = Random(issueNumber + 11);
  return weighted[random.nextInt(weighted.length)];
}

int _getIssueNumber() {
  final now = DateTime.now();
  final epoch = DateTime(2000, 1, 1);
  return now.difference(epoch).inDays;
}
