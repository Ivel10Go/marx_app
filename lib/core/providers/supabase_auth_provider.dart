import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/supabase_auth_service.dart';
import '../services/supabase_sync_service.dart';
import '../services/purchases_service.dart';
import '../../domain/providers/repository_providers.dart';

/// Stream des aktüllen Auth-Status
final supabaseAuthStateProvider = StreamProvider<AuthUser?>((ref) {
  final service = SupabaseAuthService();
  return service.authStateChanges();
});

/// Ist der Benutzer angemeldet?
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(supabaseAuthStateProvider);
  return authState.whenData((user) => user != null).value ?? false;
});

/// Aktülle User-ID
final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(supabaseAuthStateProvider);
  return authState.whenData((user) => user?.id).value;
});

/// Aktülle User-Email
final currentUserEmailProvider = Provider<String?>((ref) {
  final authState = ref.watch(supabaseAuthStateProvider);
  return authState.whenData((user) => user?.email).value;
});

class AuthController extends StateNotifier<AsyncValue<AuthUser?>> {
  AuthController(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  final Ref _ref;
  final _service = SupabaseAuthService();

  void _init() {
    _service.authStateChanges().listen(
      (user) async {
        state = AsyncValue.data(user);
        try {
          if (user != null) {
            // On login: merge local favorites to cloud and pull cloud favorites back locally
            await _onLogin(user.id);
            // Link RevenueCat to this user id
            try {
              await PurchasesService.instance.logIn(user.id);
            } catch (e) {
              // non-fatal: log and continue
            }
          }
        } catch (e) {
          // ignore sync errors here but log if needed
        }
      },
      onError: (e, st) {
        state = AsyncValue.error(e, st);
      },
    );
  }

  Future<void> _onLogin(String userId) async {
    final quoteRepo = _ref.read(quoteRepositoryProvider);

    // collect local favorite ids (quote.id strings)
    final localFavQuotes = await quoteRepo.watchFavorites().first;
    final localFavoriteIds = localFavQuotes.map((q) => q.id).toList();

    // sync local -> cloud
    await SupabaseSyncService().syncLocalFavoritesToCloud(
      userId: userId,
      localFavoriteIds: localFavoriteIds,
    );

    // fetch cloud favorites and ensure local contains them
    final cloud = await SupabaseSyncService().fetchFavoritesFromCloud(userId);
    final missingLocal = cloud
        .where((id) => !localFavoriteIds.contains(id))
        .toList();
    for (final quoteId in missingLocal) {
      try {
        await quoteRepo.addFavorite(quoteId);
      } catch (_) {
        // ignore per-item failures
      }
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      await _service.signUpWithEmail(email, password);
      // Auth state wird durch authStateChanges automatisch aktualisiert
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      await _service.signInWithEmail(email, password);
      // Auth state wird durch authStateChanges automatisch aktualisiert
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _service.signOut();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _service.resetPassword(email);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<AuthUser?>>((ref) {
      return AuthController(ref);
    });
