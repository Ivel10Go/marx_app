import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/admin/admin_dashboard_screen.dart';
import '../../presentation/detail/quote_detail_screen_new.dart';
import '../../presentation/favorites/favorites_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/premium/premium_features_screen.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../presentation/thinkers/thinkers_screen.dart';
import '../../presentation/paywall/purchase_page.dart';
import '../../domain/providers/admin_access_provider.dart';

final initialRouteProvider = Provider<String>((Ref ref) => '/');

final appRouterProvider = Provider<GoRouter>((Ref ref) {
  final initialRoute = ref.watch(initialRouteProvider);
  final isAdmin = ref.watch(adminAccessProvider);

  return GoRouter(
    initialLocation: initialRoute,
    redirect: (context, state) {
      if (state.matchedLocation == '/thinkers') {
        return '/archive';
      }
      if (state.matchedLocation == '/admin' && !isAdmin) {
        return '/';
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 180),
          reverseTransitionDuration: const Duration(milliseconds: 140),
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
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
        builder: (context, state) => const ThinkersScreen(),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 180),
          reverseTransitionDuration: const Duration(milliseconds: 140),
          child: const SettingsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/purchase',
        name: 'purchase',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 180),
          reverseTransitionDuration: const Duration(milliseconds: 140),
          child: const PurchasePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/premium-features',
        name: 'premium-features',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 180),
          reverseTransitionDuration: const Duration(milliseconds: 140),
          child: const PremiumFeaturesScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
    ],
  );
});
