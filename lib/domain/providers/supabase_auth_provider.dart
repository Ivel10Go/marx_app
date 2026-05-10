// Riverpod providers for Supabase auth
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/supabase_auth_service.dart';

final supabaseAuthServiceProvider = Provider<SupabaseAuthService>((ref) {
  return SupabaseAuthService();
});

final currentSupabaseUserProvider = StreamProvider<AuthUser?>((ref) {
  final svc = ref.watch(supabaseAuthServiceProvider);
  return svc.authStateChanges();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(currentSupabaseUserProvider);
  return userAsync.maybeWhen(data: (u) => u != null, orElse: () => false);
});

final currentUserIdProvider = Provider<String?>((ref) {
  final userAsync = ref.watch(currentSupabaseUserProvider);
  return userAsync.maybeWhen(data: (u) => u?.id, orElse: () => null);
});
