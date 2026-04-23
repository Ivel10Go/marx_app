import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/archive/archive_screen.dart';
import '../../presentation/detail/quote_detail_screen.dart';
import '../../presentation/favorites/favorites_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/quiz/quiz_screen.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../presentation/thinkers/thinkers_screen.dart';

final initialRouteProvider = Provider<String>((Ref ref) => '/');

final appRouterProvider = Provider<GoRouter>((Ref ref) {
  final initialRoute = ref.watch(initialRouteProvider);

  return GoRouter(
    initialLocation: initialRoute,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return QuoteDetailScreen(quoteId: id);
        },
      ),
      GoRoute(
        path: '/archive',
        name: 'archive',
        builder: (context, state) => const ArchiveScreen(),
      ),
      GoRoute(
        path: '/thinkers',
        name: 'thinkers',
        builder: (context, state) => const ThinkersScreen(),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/quiz',
        name: 'quiz',
        builder: (context, state) => const QuizScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
  );
});
