import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/supabase_auth_service.dart';

/// Stream des aktuellen Auth-Status
final supabaseAuthStateProvider = StreamProvider<AuthUser?>((ref) {
  final service = SupabaseAuthService();
  return service.authStateChanges();
});

/// Ist der Benutzer angemeldet?
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(supabaseAuthStateProvider);
  return authState.whenData((user) => user != null).value ?? false;
});

/// Aktuelle User-ID
final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(supabaseAuthStateProvider);
  return authState.whenData((user) => user?.id).value;
});

/// Aktuelle User-Email
final currentUserEmailProvider = Provider<String?>((ref) {
  final authState = ref.watch(supabaseAuthStateProvider);
  return authState.whenData((user) => user?.email).value;
});

class AuthController extends StateNotifier<AsyncValue<AuthUser?>> {
  AuthController() : super(const AsyncValue.loading()) {
    _init();
  }

  final _service = SupabaseAuthService();

  void _init() {
    _service.authStateChanges().listen(
      (user) {
        state = AsyncValue.data(user);
      },
      onError: (e, st) {
        state = AsyncValue.error(e, st);
      },
    );
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
      return AuthController();
    });
