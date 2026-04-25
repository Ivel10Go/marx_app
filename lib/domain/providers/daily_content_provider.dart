import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/daily_content.dart';
import '../services/daily_content_resolver.dart';
import '../services/personalization_service.dart';
import 'app_mode_provider.dart';
import 'repository_providers.dart';
import 'settings_provider.dart';
import 'user_profile_provider.dart';

final personalizationServiceProvider = Provider<PersonalizationService>((
  Ref ref,
) {
  return PersonalizationService();
});

final dailyContentResolverProvider = Provider<DailyContentResolver>((Ref ref) {
  return DailyContentResolver(
    personalization: ref.watch(personalizationServiceProvider),
  );
});

final dailyContentProvider = FutureProvider<DailyContent>((Ref ref) async {
  await ref.watch(initialSeedProvider.future);
  final appMode = ref.watch(appModeNotifierProvider);
  final profile = ref.watch(userProfileProvider);
  final settings = await ref.watch(settingsControllerProvider.future);
  final quoteRepository = ref.watch(quoteRepositoryProvider);
  final historyRepository = ref.watch(historyRepositoryProvider);
  final resolver = ref.watch(dailyContentResolverProvider);
  final homeContentMode = settings.homeContentMode;
  final content = await resolver.resolveDailyContentFromRepository(
    quoteRepository: quoteRepository,
    historyRepository: historyRepository,
    homeContentMode: homeContentMode,
    appMode: appMode,
    profile: profile,
  );

  if (content == null) {
    throw Exception('No quote content available');
  }

  return content;
});
