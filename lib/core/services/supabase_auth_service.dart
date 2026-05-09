import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Lightweight auth user model used by the app.
class AuthUser {
  const AuthUser({required this.id, required this.email, this.displayName});

  final String id;
  final String email;
  final String? displayName;
}

/// Service für Supabase Authentication (Singleton)
class SupabaseAuthService {
  SupabaseAuthService._();
  static final SupabaseAuthService _instance = SupabaseAuthService._();
  factory SupabaseAuthService() => _instance;

  SupabaseClient get _client => Supabase.instance.client;

  AuthUser? _mapToAuthUser(User? user) {
    if (user == null) return null;
    return AuthUser(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['display_name'] as String?,
    );
  }

  /// Stream für Auth State Changes
  Stream<AuthUser?> authStateChanges() {
    return _client.auth.onAuthStateChange.map((event) {
      return _mapToAuthUser(event.session?.user);
    });
  }

  /// Aktueller angemeldeter User
  AuthUser? get currentUser => _mapToAuthUser(_client.auth.currentUser);

  /// Ist der Benutzer angemeldet?
  bool get isAuthenticated => _client.auth.currentUser != null;

  /// Email/Passwort Registrierung
  Future<AuthUser> signUpWithEmail(String email, String password) async {
    try {
      final res = await _client.auth.signUp(email: email, password: password);
      final user = res.user;
      if (user == null)
        throw Exception('Benutzer konnte nicht registriert werden');
      return _mapToAuthUser(user)!;
    } catch (e) {
      rethrow;
    }
  }

  /// Email/Passwort Login
  Future<AuthUser> signInWithEmail(String email, String password) async {
    try {
      final res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = res.user;
      if (user == null) throw Exception('Anmeldung fehlgeschlagen');
      return _mapToAuthUser(user)!;
    } catch (e) {
      rethrow;
    }
  }

  /// Abmelden
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Passwort zurücksetzen (send reset email)
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }
}
