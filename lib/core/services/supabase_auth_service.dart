import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthUser {
  const AuthUser({required this.id, required this.email, this.displayName});

  final String id;
  final String email;
  final String? displayName;
}

/// Service für Supabase Authentication
class SupabaseAuthService {
  SupabaseAuthService._();
  static final SupabaseAuthService _instance = SupabaseAuthService._();

  factory SupabaseAuthService() => _instance;

  SupabaseClient get _client => Supabase.instance.client;
  Session? get _currentSession => _client.auth.currentSession;

  /// Konvertiert Supabase User zu AuthUser
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

  /// Aktüller angemeldeter User
  AuthUser? get currentUser {
    return _mapToAuthUser(_currentSession?.user);
  }

  /// Ist der Benutzer angemeldet?
  bool get isAuthenticated => _currentSession != null;

  /// Email/Passwort Registrierung
  Future<AuthUser> signUpWithEmail(String email, String password) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Benutzer konnte nicht registriert werden');
      }

      return _mapToAuthUser(user)!;
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  /// Email/Passwort Login
  Future<AuthUser> signInWithEmail(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Anmeldung fehlgeschlagen');
      }

      return _mapToAuthUser(user)!;
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  /// Abmelden
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  /// Passwort zurücksetzen
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  /// Fehlerbehandlung
  String _mapAuthException(AuthException e) {
    switch (e.statusCode) {
      case 'user_already_exists':
        return 'Diese E-Mail-Adresse ist bereits registriert';
      case 'invalid_credentials':
        return 'E-Mail oder Passwort ist ungültig';
      case 'email_not_confirmed':
        return 'Bitte bestätigen Sie Ihre E-Mail-Adresse';
      case 'over_email_send_rate_limit':
        return 'Zu viele Anfragen. Bitte warten Sie einen Moment.';
      case 'weak_password':
        return 'Passwort ist zu schwach. Mindestens 6 Zeichen erforderlich.';
      default:
        return 'Fehler: ${e.message}';
    }
  }
}
