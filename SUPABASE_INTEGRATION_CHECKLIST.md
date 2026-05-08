# Supabase Integration — Schnell-Checklist

Diese Checklist führt dich durch alle Schritte um Supabase in der Marx App zu integrieren.

---

## ✅ PHASE 0: VORBEREITUNG (Jetzt)

- [ ] **Pubspec.yaml aktualisiert** — `supabase_flutter` hinzugefügt
  - Status: ✅ Fertig
  - Befehl: `flutter pub get`

- [ ] **Services & Provider erstellt**
  - [x] `lib/core/services/supabase_auth_service.dart`
  - [x] `lib/core/services/supabase_sync_service.dart`
  - [x] `lib/core/providers/supabase_auth_provider.dart`
  - [x] `SUPABASE_SETUP.md` Guide

---

## 📋 PHASE 1: SUPABASE BACKEND SETUP (20-30 Min)

**Folge:** [SUPABASE_SETUP.md](SUPABASE_SETUP.md) → Phase 1-3

- [ ] **Konto erstellen & Projekt anlegen**
  - [ ] Supabase.com Account
  - [ ] "Marx Zitatatlas" Projekt
  - [ ] Region gewählt (z.B. Frankfurt)
  - [ ] Warten auf Initialisierung

- [ ] **Credentials kopieren & speichern**
  - [ ] Project URL → `SUPABASE_URL`
  - [ ] Anon Key → `SUPABASE_ANON_KEY`
  - [ ] Service Role Key (sicher speichern)

- [ ] **Database Schema deployen**
  - [ ] Profiles Table erstellt
  - [ ] User Favorites Table erstellt
  - [ ] Trigger `handle_new_user()` aktiv
  - [ ] RLS Policies aktiviert

- [ ] **Authentication konfigurieren**
  - [ ] Email Provider aktiviert
  - [ ] Google & Apple konfiguriert (optional)
  - [ ] Redirect URLs hinzugefügt

- [ ] **Test User & RLS getestet**
  - [ ] Test User erstellt
  - [ ] SQL SELECT bestätigt
  - [ ] RLS Sicherheit getestet

---

## 🔧 PHASE 2: FLUTTER INTEGRATION (1-2 Std)

### 2.1 Environment Setup

- [ ] **.env File erstellen**
  ```
  SUPABASE_URL=https://xxxxx.supabase.co
  SUPABASE_ANON_KEY=eyJhbGc...
  ```
  - Speichern in Projekt-Root
  - In `.gitignore` hinzufügen

- [ ] **flutter_dotenv hinzufügen**
  ```bash
  flutter pub add flutter_dotenv
  ```

- [ ] **pubspec.yaml aktualisiert**
  ```yaml
  flutter:
    assets:
      - .env
  ```

### 2.2 Main.dart Integration

- [ ] **Supabase Initialization in main.dart**
  ```dart
  import 'package:flutter_dotenv/flutter_dotenv.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    await dotenv.load();
    
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    
    runApp(const _BootstrapGateApp());
  }
  ```

- [ ] **Flutter Packages aktualisiert**
  ```bash
  flutter pub get
  flutter pub upgrade supabase_flutter
  ```

- [ ] **App startet ohne Fehler**
  ```bash
  flutter run -d <device-id>
  ```

---

## 🔐 PHASE 3: AUTH FLOW TESTING (30-45 Min)

### 3.1 Unit Tests — SupabaseAuthService

- [ ] **Test: Sign Up erfolgreich**
  ```dart
  test('Should sign up new user', () async {
    final service = SupabaseAuthService();
    final user = await service.signUpWithEmail(
      'newuser@test.com',
      'Password123!',
    );
    expect(user.email, 'newuser@test.com');
  });
  ```

- [ ] **Test: Sign In erfolgreich**
  ```dart
  test('Should sign in existing user', () async {
    final service = SupabaseAuthService();
    final user = await service.signInWithEmail(
      'test@example.com',
      'TestPassword123!',
    );
    expect(user.id, isNotEmpty);
  });
  ```

- [ ] **Test: Sign Out erfolgreich**
  ```dart
  test('Should sign out', () async {
    final service = SupabaseAuthService();
    await service.signOut();
    expect(service.isAuthenticated, false);
  });
  ```

- [ ] **Test: Error Handling**
  ```dart
  test('Should throw on invalid credentials', () async {
    final service = SupabaseAuthService();
    expect(
      () => service.signInWithEmail('test@example.com', 'wrong'),
      throwsException,
    );
  });
  ```

### 3.2 Manual Testing — Auth Flow

- [ ] **Sign Up Flow**
  - [ ] Öffne App
  - [ ] Navigiere zu Settings (placeholder)
  - [ ] "Anmelden" Button (noch nicht UI)
  - [ ] Email & Passwort eingeben
  - [ ] Sign Up aufrufen
  - [ ] Prüfe: Profile in Supabase Console erstellt

- [ ] **Sign In Flow**
  - [ ] App neustarten
  - [ ] Mit Test-Account anmelden
  - [ ] Prüfe: Auth State Provider gibt User zurück

- [ ] **Sign Out Flow**
  - [ ] Von Settings aus abmelden
  - [ ] Prüfe: Auth State Provider gibt `null` zurück

- [ ] **Error Handling**
  - [ ] Sign Up mit bestehender Email → Error Nachricht
  - [ ] Login mit falschem Passwort → Error Nachricht
  - [ ] Netzwerk aus → Timeout Error

---

## 🎨 PHASE 4: UI INTEGRATION (1-2 Std)

### 4.1 Account Section in Settings

- [ ] **Settings Screen anpassen**
  - Datei: [lib/presentation/settings/settings_screen.dart](lib/presentation/settings/settings_screen.dart)
  - [ ] New Section: "ACCOUNT"
  - [ ] Wenn nicht angemeldet: "Anmelden" Button
  - [ ] Wenn angemeldet: User Email + "Abmelden" Button

- [ ] **Widget: AccountCard**
  ```dart
  class _AccountSection extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final authState = ref.watch(supabaseAuthStateProvider);
      
      return authState.when(
        data: (user) => user == null
          ? _NotLoggedInCard()
          : _LoggedInCard(user: user),
        loading: () => const LoadingState(),
        error: (e, st) => const ErrorState(),
      );
    }
  }
  ```

### 4.2 Login/Signup Modal

- [ ] **Sheet Component erstellen**
  - Datei: [lib/presentation/auth/auth_sheet.dart](lib/presentation/auth/auth_sheet.dart)
  - [ ] Email/Passwort Form
  - [ ] Login/Signup Tab-Umschalter
  - [ ] Loading State während Auth
  - [ ] Error Messages anzeigen
  - [ ] "Passwort vergessen?" Link

- [ ] **Settings → "Anmelden" Button öffnet Sheet**
  ```dart
  showModalBottomSheet(
    context: context,
    builder: (context) => const AuthSheet(),
  );
  ```

### 4.3 Account Details Screen (Optional für Phase 1)

- [ ] **Neu Screen: [lib/presentation/settings/account_screen.dart](lib/presentation/settings/account_screen.dart)**
  - [ ] User Email anzeigen
  - [ ] "Passwort ändern" Button
  - [ ] "Konto löschen" Button (mit Confirmation)
  - [ ] "Daten exportieren" Button

---

## ☁️ PHASE 5: FAVORITES SYNC (1-2 Std)

### 5.1 Favorites Provider Update

- [ ] **Cloud Sync hinzufügen**
  - Datei: [lib/domain/providers/favorites_provider.dart](lib/domain/providers/favorites_provider.dart)
  - [ ] Nach Login: `syncLocalFavoritesToCloud()` aufrufen
  - [ ] Merge: Alle lokalen Favoriten → Cloud

- [ ] **Sync Trigger bei Login**
  ```dart
  final authState = ref.watch(supabaseAuthStateProvider);
  
  authState.whenData((user) {
    if (user != null) {
      // Sync lokale Favoriten zu Cloud
      syncService.syncLocalFavoritesToCloud(
        userId: user.id,
        localFavoriteIds: localFavorites,
      );
    }
  });
  ```

### 5.2 Realtime Updates (Optional, Phase 2)

- [ ] **Stream abonnieren**
  ```dart
  final cloudFavoritesProvider = StreamProvider<List<int>>((ref) {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return const Stream.empty();
    
    return SupabaseSyncService().favoritesStream(userId);
  });
  ```

---

## 🔗 PHASE 6: REVENUECAT INTEGRATION (30 Min)

### 6.1 Login/Logout mit RevenueCat

- [ ] **Bei erfolgreichem Login**
  ```dart
  await Purchases.logIn(user.id);
  ```

- [ ] **Bei Logout**
  ```dart
  await Purchases.logOut();
  // Generate new anonymous ID
  ```

- [ ] **Test: Entitlements bleiben nach Login**
  - [ ] Kauf Pro-Abo (Sandbox)
  - [ ] Logout
  - [ ] Login mit neuem Account
  - [ ] Prüfe: Pro nicht aktiv
  - [ ] Kaufe Pro auf neuem Account
  - [ ] Prüfe: Pro ist aktiv

---

## ✅ ABSCHLUSS-CHECKLIST

- [ ] Supabase Backend vollständig konfiguriert
- [ ] Flutter Services & Provider implementiert & getestet
- [ ] Auth Flow funktioniert (Sign Up, Sign In, Sign Out)
- [ ] Account Section in Settings sichtbar
- [ ] Login/Signup Modal funktioniert
- [ ] Favoriten werden zu Cloud synced
- [ ] RevenueCat + Supabase Login-Flow funktioniert
- [ ] Keine Secrets im Code (nutze .env)
- [ ] RLS Policies gesichert
- [ ] Unit & Integration Tests geschrieben

---

## 📊 Metriken zum Tracken

Nach Phase 3.5 Completion:

| Metrik | Ziel | Status |
|--------|------|--------|
| Auth Service Unit Tests | 100% Pass | ☐ |
| E2E Auth Flow | Funktioniert | ☐ |
| Favoriten Cloud-Sync | Working | ☐ |
| RevenueCat + Auth | Working | ☐ |
| Settings Account UI | Implemented | ☐ |

---

## 🚀 Nächste Phasen nach 3.5

1. **Phase 3.5.1** — Account Details Screen (Passwort, Konto löschen)
2. **Phase 3.5.2** — DSGVO Compliance (Data Export, Deletion)
3. **Phase 4** — Google Play Store Preparation
4. **Phase 5** — Post-Launch Monitoring

---

**Last Updated:** 8. Mai 2026  
**Owner:** Development Team  
**Status:** In Progress (Phase 1 Supabase Setup)
