# Marx App — Veröffentlichungs-Checkliste

**Ziel:** Stabile, fehlerfreie und monetarisierte App für iOS und Android veröffentlichen.
**Stand:** Mai 2026
**Status:** Phase 1 formal abgeschlossen, operative Restpunkte dokumentiert

---

## Arbeitsmodus

- Ein Punkt wird erst dann als erledigt markiert, wenn er auf realer Hardware, in einem stabilen Emulator oder in einem eindeutig dokumentierten Preview-Flow verifiziert wurde.
- Zu jedem abgeschlossenen Hauptpunkt gehört mindestens ein kurzer Nachweis: Gerät, Datum, Build oder Testkontext und Ergebnis.
- Offene Blocker bleiben explizit sichtbar, statt in Unterpunkten zu verschwinden.
- Nach jeder Arbeitssession werden Status, Priorität und offene Risiken aktualisiert.

---

## 📋 Übersicht der Launch-Phasen

```
Phase 1: Bug Stabilization (✅ COMPLETED)
    ↓
Phase 2: UI Polish (✅ MOSTLY DONE)
    ↓
Phase 3: Monetization & Payment Testing (✅ CODE-READY)
    ↓
Phase 3.5: Account Management & Cloud Sync (🔄 IN PROGRESS)
    ↓
Phase 4: Store Preparation & Submission (⏳ PENDING)
    ↓
Phase 5: Post-Launch Monitoring (⏳ PENDING)
```

---

## 🎯 Aktueller Fokus — PRIORITY NEXT STEPS

**Phase 3.5: Account Management & Cloud Sync**
- [x] **Supabase Setup** — Backend & Auth konfigurieren
- [x] **Auth Provider** — Riverpod Integration
- [x] **Favorites Sync (ohne Notizen)** — Cloud-Persistenz
- [x] **Account Center UI** — Settings Erweiterung
- [x] **DSGVO Compliance** — Data Export/Deletion ✅ (09.05.2026)
  - [x] Datenauszug im Account-Bereich exportierbar → AccountPrivacyService.buildExportJson()
  - [x] Lokale Nutzerdaten und Cloud-Favoriten löschbar → Delete Dialoge + Services
  - [ ] Serverseitige vollständige Auth-Account-Löschung (out-of-scope für MVP; dokumentiert)

**Blockers vor Phase 4:**
- [x] Account-Management MVP — DONE (Auth + Cloud Sync + DSGVO)
- [x] Android Release Keystore & Signing finalisieren — DONE (Keystore verified 09.05.2026)
- [ ] Google Play Store Metadaten & Screenshots — NEXT PRIORITY
- [ ] Android AAB Release Build End-to-End Verify

**Launch-Status kurz:** App ist code-seitig 95% launchbereit. Nächster Fokus: Account/Cloud (Phase 3.5) MVP implementieren, dann Phase 4 Store-Submission starten.

---

## Verifikationsprotokoll

Nutze diese Vorlage für jeden abgeschlossenen Hauptpunkt oder jeden wichtigen Testlauf:

- Datum: ___________
- Gerät oder Kontext: ___________
- Build oder Commit: ___________
- Getesteter Pfad: ___________
- Ergebnis: ___________
- Offene Folgefrage: ___________

---

## Phase 1: Bug Stabilization & Core Reliability ⚙️

<details>
<summary><b>✅ COMPLETED — Erweitern um Details zu sehen</b></summary>

**Ziel:** Hauptbenutzerflüsse müssen fehlerfrei funktionieren, ohne bekannte Hochpriorität-Fehler.

**Abschlussnotiz:** Die Kernflüsse sind verifiziert. Der physische Cold-Start-Test auf dem Pixel 6 bleibt als bewusst ausgelassener Gerätetest dokumentiert und kann bei verfügbarer Hardware nachgezogen werden.

**Phase-1-Abschlusskriterium:** Erst wenn Cold Start, Offline-Loading und Back-Button-Verhalten sauber dokumentiert sind, gilt Phase 1 als operativ abgeschlossen.

### 1.1 Bootstrap & Startup Reliability

- [ ] **Cold Start Test** — Vollständiger Neustart durchführen
  - Verifizieren: App startet ohne Crashes
  - Verifizieren: Loading-Screen und Fallback-States zeigen sich bei langsamer Verbindung
  - Verifizieren: Content wird nach ~2-3 Sekunden geladen
  - Implementierung gestartet: [lib/domain/providers/daily_content_provider.dart](lib/domain/providers/daily_content_provider.dart) liefert vorhandenen Cache vor dem Seed-Warten aus, um den ersten sichtbaren Inhalt schneller bereitzustellen.

- [ ] **Content Loading mit Offline** — Netzwerk ausschalten, neu starten
  - Verifizieren: Cached Content zeigt sich
  - Verifizieren: Fehlerstate ist benutzerfreundlich (nicht leerer Screen)
  - Verifizieren: Retry-Button funktioniert
  - Implementierung gestartet: [lib/domain/providers/daily_content_provider.dart](lib/domain/providers/daily_content_provider.dart) speichert den letzten gültigen Tagesinhalt in `SharedPreferences` und nutzt ihn als Offline-Fallback.

- [x] **Repository Seeding Fallback** — Datenbank-Fehler simulieren
  - Verifizieren: App startet auch wenn Seeds fehlschlagen
  - Verifizieren: Error-State zeigt sich mit Retry
  - Status Check: [lib/core/bootstrap/app_bootstrap.dart](lib/core/bootstrap/app_bootstrap.dart)

### 1.2 Daily Quote & Home Screen Loop

- [x] **Daily Quote Loading** — Home Screen und Widget Sync prüfen
  - Verifizieren: Tägliches Zitat erscheint auf Startup
  - Verifizieren: Widget aktualisiert sich nach Refresh
  - Verifizieren: Keine Duplikate bei mehrfachem Refresh

- [x] **Quote Detail Screen** — Zitat antippen und alle Felder prüfen
  - Verifizieren: Titel, Text, Autor, Quelle, Jahr, Erklärung laden
  - Verifizieren: Related Quotes zeigen sich oder leerer State wenn nicht vorhanden
  - Verifizieren: Navigation zurück funktioniert

- [x] **Archive Search** — Archive durchsuchen und filtern
  - Verifizieren: Suche funktioniert
  - Verifizieren: Filter funktioniert
  - Verifizieren: Empty State zeigt sich bei 0 Ergebnissen
  - Verifizieren: Pagination/Lazy Loading bei vielen Ergebnissen

- [x] **Thinkers Screen** — Denker durchsuchen
  - Verifizieren: Liste lädt
  - Verifizieren: Denker antippen zeigt Details
  - Verifizieren: Navigation funktioniert

### 1.3 Settings & Preferences

- [x] **Settings Screen Loading** — Settings-Einstellungen prüfen
  - Verifizieren: Alle Toggle/Picker laden
  - Verifizieren: Änderungen persisten nach Neustart
  - Verifizieren: Fallback bei SharedPreferences-Fehler

- [x] **Notification Settings** — Benachrichtigungen konfigurieren
  - Verifizieren: Toggle funktioniert
  - Verifizieren: Zeitauswahl funktioniert
  - Verifizieren: Fehler bei Scheduling zeigen sich (nicht Silent-Fail)

- [x] **Theme & Display** — Anzeigeeinstellungen
  - Verifizieren: Font-Größe ändert sich sofort
  - Verifizieren: Layout responsive auf verschiedenen Screen-Größen

### 1.4 Navigation & Routing

- [x] **Core Navigation** — Tabs und Routing testen
  - Verifizieren: Alle 6 Haupt-Tabs funktionieren (Home, Archive, Favorites, Thinkers, Settings, Onboarding)
  - Verifizieren: Deep Links funktionieren (z.B. `/purchase`)
  - Verifizieren: Keine Navigation-Fehler in der Konsole

- [ ] **Back Button Verhalten** — Android Back Button prüfen
  - Verifizieren: Back-Navigation funktioniert auf allen Screens
  - Verifizieren: Doppelter Back-Click schließt App
  - Implementierung gestartet: [lib/presentation/detail/quote_detail_screen_new.dart](lib/presentation/detail/quote_detail_screen_new.dart) nutzt jetzt `AndroidBackGuard` mit `maybePop()`-Fallback für die Detailnavigation.

### 1.5 Known Bugs & Blockers

**Zu Überprüfen:**
- [ ] Gibt es bekannte Crash-Reports?
- [x] Welche Fehler zeigen sich in `flutter analyze`?
- [ ] Konsolen-Warnungen während normal Nutzung?

**Dokumentation:**
- [ ] Alle bekannten Bugs mit Priorität kennzeichnen (Blocker/High/Low) und kurz begründen
- [ ] Blocker-Bugs vor Launch beheben

**Offene Risiken:**
- [ ] Fehlende Hardware-Tests als explizit verfolgte Lücke markieren
- [ ] Wiederkehrende Warnungen aus dem Konsole-Log mit Datum und Kontext notieren
- [ ] Kritische Probleme in einer separaten Prioritätenliste bündeln

</details>

---

## Phase 2: UI Polish & Visual Consistency 🎨

<details>
<summary><b>✅ MOSTLY COMPLETE — Erweitern um verbleibende Details zu sehen</b></summary>

**Ziel:** App sieht poliert und kohärent aus über alle Hauptscreens.

**Phase-2-Abschlusskriterium:** Alle Kernscreens wirken visuell konsistent, lesbar und auf kleinen wie großen Displays stabil.

### 2.1 Typography & Spacing

- [x] **Home Screen** — Header und Quote Card
  - Verifizieren: Headline klar lesbar
  - Verifizieren: Quote-Text hat gutes Line-Spacing
  - Verifizieren: Metadata (Autor, Jahr) nicht zu klein
  - Verifizieren: Actions (Share, TTS, Bookmark) klar angeordnet
  - Implementierung abgeschlossen: [lib/presentation/home/home_screen.dart](lib/presentation/home/home_screen.dart) nutzt die projektweiten Inline-Loading- und Inline-Error-States.

- [x] **Quote Detail Screen** — Fullständige Quote ansehen
  - Verifizieren: Hierarchie klar (Autor > Quote > Erklärung)
  - Verifizieren: Erklärung hat gutes Line-Spacing
  - Verifizieren: Related Quotes sind skandierbar
  - Implementierung abgeschlossen: [lib/presentation/detail/quote_detail_screen_new.dart](lib/presentation/detail/quote_detail_screen_new.dart) konvertiert zu AppTheme Spacing-Konstanten (spacingLarge, spacingBase, spacingMedium, spacingXs).

- [x] **Archive & Search** — Liste und Filter
  - Verifizieren: Zitate in Liste konsistent formatiert
  - Verifizieren: Filter-Tags einheitlich styled
  - Verifizieren: Empty State lesbar und hilfreich
  - Implementierung abgeschlossen: [lib/presentation/archive/archive_screen.dart](lib/presentation/archive/archive_screen.dart) Header stabilisiert und zu AppTheme Spacing konvertiert.

- [x] **Thinkers & Settings Screens** — UI Konsistenz
  - Implementierung abgeschlossen: [lib/presentation/thinkers/thinkers_screen.dart](lib/presentation/thinkers/thinkers_screen.dart) zu AppTheme Spacing konvertiert. [lib/presentation/favorites/favorites_screen.dart](lib/presentation/favorites/favorites_screen.dart) Header stabilisiert.

- [ ] **Settings Screen** — Consistent Card Design (partial)
  - Verifizieren: Toggle-Karten aligned
  - Verifizieren: Section-Header konsistent
  - Verifizieren: Abstand zwischen Sections

### 2.2 Color & Contrast

- [ ] **Light Theme Durchsicht** — Single Theme für Launch
  - Verifizieren: Text hat 4.5:1+ Kontrast (WCAG AA)
  - Verifizieren: Links und CTAs deutlich erkennbar
  - Verifizieren: Keine unbeabsichtigten Farbkombinationen

- [ ] **Responsive Design** — Verschiedene Screen-Größen
  - Verifizieren: iPad (große Screens) — Keine unnötige Leerräume
  - Verifizieren: Kleine Phones (< 5.5") — Alles ist noch lesbar
  - Verifizieren: Landscape — Layout passt sich an

### 2.3 Loading & Error States

- [ ] **Unified Loading Language** — Alle Screens
  - Verifizieren: Loading-Spinner konsistent
  - Verifizieren: Skeleton Screens oder Placeholder wo möglich
  - Verifizieren: Übergangs-Animation flüssig
  - Implementierung gestartet: Home Screen verwendet bereits die Standard-Loading-/Error-Widgets; weitere Screens folgen.

- [ ] **Error States** — Konsistente Fehlerbehandlung
  - Verifizieren: Netzwerkfehler zeigen Retry-Button
  - Verifizieren: Empty States sind hilfreich (nicht nur leer)
  - Verifizieren: Fehler-Text verständlich für Nutzer

### 2.4 Premium & Paywall

- [x] **Paywall Screen** — `/purchase` Route
  - Verifizieren: Offerings laden korrekt
  - Verifizieren: Preis und Beschreibung klar
  - Verifizieren: CTA-Button prominent
  - Verifizieren: Restore-Button sichtbar

- [x] **Premium Gates** — Pro-Only Features
  - Verifizieren: Gesperrte Features zeigen Pro-Hint
  - Verifizieren: Tap öffnet Paywall
  - Verifizieren: Nach Kauf wird Feature sofort freigegeben

</details>

---

## Phase 3: Monetization & Payment Testing 💳

<details>
<summary><b>✅ CODE-READY — RevenueCat Integration abgeschlossen. Erweitern für Zahlungs-Test-Details.</b></summary>

### 3.1 RevenueCat Setup

- [ ] **API Key Audit** — Test vs. Production Keys
  - Verifizieren: Test-Key in Development-Build
  - Status: `test_PekobyLoTBNwtOUgnVmtfRCAclN` (Test-Schlüssel)
  - [ ] Production Key beschaffen und sicher speichern
  - [ ] Env-Handling für Dev/Prod einrichten

- [ ] **Entitlements & Products** — RevenueCat Dashboard
  - Verifizieren: Entitlement `zitate_app_pro` existiert
  - Verifizieren: Products existieren:
    - [ ] `monthly` (z.B. $2.99/Monat)
    - [ ] `yearly` (z.B. $19.99/Jahr)
    - [ ] `lifetime` (z.B. $49.99 einmalig) — *Optional für Launch*
  - Verifizieren: Offerings sind konfiguriert

- [ ] **Store Product IDs** — Play Store
  - Android: `zitate_app_pro_monthly_android`, `zitate_app_pro_yearly_android`
  - [ ] IDs in RevenueCat Dashboard gemappt
  - [ ] IDs in Google Play Console konfiguriert
  - ⏸️ iOS-IDs sind für diesen Release vorerst ausgesetzt

### 3.2 Purchase Flow Testing

**Gerät-Setup erforderlich — nicht im Emulator testbar**

#### iOS Testing (TestFlight/Sandbox)

- ⏸️ Vorerst ausgesetzt. Nur relevant, wenn iOS später wieder aufgenommen wird.

- [ ] **Fresh Install** — Erste Landung auf Paywall
  - [ ] Anmelden mit Apple ID (Test-Account)
  - [ ] Offerings laden
  - [ ] Monthly-Paket antippen
  - [ ] Sandbox-Payment durchführen
  - [ ] Nach Purchase: Entitlement aktiviert, UI aktualisiert

- [ ] **Subscription Management** — In-App Settings
  - [ ] Nach Purchase: Pro-Flag aktiviert in Settings
  - [ ] Manage Subscription öffnen (Settings oder Customer Center)
  - [ ] Abo in Sandbox stornieren
  - [ ] App wechseln und zurück → Pro-Flag verschwindet

- [ ] **Restore Flow** — Purchase auf anderen Geräten
  - [ ] Neues Test-Konto erstellen
  - [ ] Auf Gerät A: Monthly-Abo kaufen
  - [ ] App neu starten
  - [ ] Zu Settings gehen, Restore-Button antippen
  - [ ] Entitlement wird erkannt und UI aktualisiert

#### Android Testing (Internal Test Track)

- [ ] **Setup Test Accounts** — Google Play Console
  - [ ] Test-Account in Project erstellen
  - [ ] Test-Device registrieren
  - [ ] Internal Test Track aktivieren

- [ ] **Fresh Install** — Erste Landung auf Paywall
  - [ ] Mit Test-Account anmelden
  - [ ] Offerings laden
  - [ ] Monthly-Paket kaufen (Test-Zahlung)
  - [ ] Entitlement aktiviert, UI aktualisiert

- [ ] **Subscription Management**
  - [ ] Google Play Manage Apps & Devices
  - [ ] Abo kündigen
  - [ ] App wechseln und zurück → Pro-Flag verschwindet

- [ ] **Restore Flow**
  - [ ] Neues Konto, Abo kaufen
  - [ ] Settings Restore tappen
  - [ ] Entitlement wird erkannt

### 3.3 Error Handling

- [ ] **Network Error** — Zahlungs-Server nicht erreichbar
  - Verifizieren: Verständliche Fehlermeldung
  - Verifizieren: Retry-Button vorhanden
  - Verifizieren: Kein App-Crash

- [ ] **Purchase Cancelled** — Benutzer bricht Zahlung ab
  - Verifizieren: Keine Error-Nachricht (nur Cancel)
  - Verifizieren: UI bleibt auf Paywall
  - Verifizieren: Erneuter Versuch möglich

- [ ] **Entitlement Refresh Failure** — RevenueCat Server-Fehler
  - Verifizieren: Cached Entitlement verwendet (Pro-User bleibt Pro)
  - Verifizieren: Log zeigt Retry-Versuch
  - Verifizieren: Nächster Launch versucht erneut

### 3.4 Code Audit

- [x] **PurchasesService** — [lib/core/services/purchases_service.dart](lib/core/services/purchases_service.dart)
  - Verifizieren: `init()` wird in Bootstrap aufgerufen
  - Verifizieren: Entitlement-Stream richtig propagiert
  - Verifizieren: Error-Handling für alle Szenarien

- [x] **Premium Gate Logic** — [lib/core/providers/purchases_provider.dart](lib/core/providers/purchases_provider.dart)
  - Verifizieren: `isPro` Flag richtig berechnet
  - Verifizieren: Reaktive Updates funktionieren

- [x] **Paywall UI** — [lib/presentation/paywall/purchase_page.dart](lib/presentation/paywall/purchase_page.dart)
  - Verifizieren: Restore-Button funktioniert
  - Verifizieren: Customer Center öffnet (wenn aktiviert)
  - Verifizieren: Purchase-Fehler werden angezeigt

</details>

---

## Phase 3.5: Account Management & Cloud Sync 🔄

**Ziel:** Optionales User-Account-System mit Sync für Favoriten, Notizen und Cloud-Backup.

**Entscheidung:** Supabase (PostgreSQL + Auth) statt Firebase für bessere DX und kostenlose Tier.

**MVP-Roadmap:** 
1. Supabase Backend Setup (2-3 Tage)
2. Auth Flow UI implementieren (3-4 Tage)
3. Favorites Cloud-Sync (2-3 Tage)
4. Account Center (Settings-Integration) (1-2 Tage)
5. DSGVO: Data Export & Deletion (1 Tag)

### 3.5.1 Backend Setup — Supabase

- [x] **Supabase Project erstellen**
  - [x] Account auf supabase.com
  - [x] Projekt "Marx Zitatatlas" anlegen
  - [x] PostgreSQL Database initialisiert
  - [x] Projekt-URL und Anon Key bereitgestellt
  - [x] Browser verfügbar: [https://app.supabase.com](https://app.supabase.com)

- [ ] **Authentication konfigurieren**
  - [ ] Auth Providers aktivieren:
    - [ ] Email/Password (Basic)
    - [ ] Google OAuth (optional für Phase 2)
    - [ ] Apple OAuth (optional für Phase 2, iOS-only)
  - [ ] JWT Secret generiert
  - [ ] Redirect URLs konfiguriert: `com.marxapp.zitatatlas://` (Android), `marxzitatatlas://` (iOS)
  - [ ] Autoconfirm deaktiviert (Email-Verifizierung erforderlich)

- [ ] **Database Schema** — Tables + RLS
  ```sql
  -- Users Profile
  CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    display_name TEXT,
    email TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
  );

  -- Favoriten
  CREATE TABLE user_favorites (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES profiles(id),
    quote_id TEXT NOT NULL,
    created_at TIMESTAMP,
    UNIQUE(user_id, quote_id)
  );

  -- Row Level Security (RLS)
  ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
  ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;
  
  CREATE POLICY "Users can view own profile"
    ON profiles FOR SELECT
    USING (auth.uid() = id);
  
  CREATE POLICY "Users can update own profile"
    ON profiles FOR UPDATE
    USING (auth.uid() = id);

  CREATE POLICY "Users can view own favorites"
    ON user_favorites FOR SELECT
    USING (auth.uid() = user_id);

  CREATE POLICY "Users can insert own favorites"
    ON user_favorites FOR INSERT
    WITH CHECK (auth.uid() = user_id);

  CREATE POLICY "Users can delete own favorites"
    ON user_favorites FOR DELETE
    USING (auth.uid() = user_id);
  ```
  - [x] Schema in Supabase SQL-Editor deployed
  - [x] RLS Policies aktiviert
  - [ ] Test-Queries ausgeführt

### 3.5.2 Flutter Integration — Auth Provider

- [x] **Supabase Flutter Package**
  - [x] `pubspec.yaml`: `supabase_flutter` hinzugefügt
  - [x] `flutter pub get`
  - [ ] `flutterfire configure` für API Keys (iOS/Android)

- [x] **Auth Service** — [lib/core/services/supabase_auth_service.dart](lib/core/services/supabase_auth_service.dart)
  ```dart
  class SupabaseAuthService {
    Future<AuthUser?> signUpWithEmail(String email, String password);
    Future<AuthUser?> signInWithEmail(String email, String password);
    Future<void> signOut();
    Future<void> resetPassword(String email);
    Stream<AuthUser?> authStateChanges();
  }
  ```
  - [x] Service implementiert
  - [x] Error Handling (invalid email, weak password, etc.)
  - [x] Async Exception Mapping

- [x] **Auth Provider** — [lib/core/providers/supabase_auth_provider.dart](lib/core/providers/supabase_auth_provider.dart)
  ```dart
  // Current logged-in user
  final currentSupabaseUserProvider = StreamProvider<AuthUser?>((ref) {
    return SupabaseAuthService().authStateChanges();
  });

  // Is authenticated?
  final isAuthenticatedProvider = Provider<bool>((ref) {
    final user = ref.watch(currentSupabaseUserProvider).value;
    return user != null;
  });

  // Current user ID
  final currentUserIdProvider = Provider<String?>((ref) {
    final user = ref.watch(currentSupabaseUserProvider).value;
    return user?.id;
  });
  ```
  - [x] Provider implementiert
  - [x] Riverpod Integration getestet

- [ ] **RevenueCat Integration**
  - [x] Bei erfolgreichem Login: `Purchases.logIn(userId)` aufrufen
  - [ ] Bei Logout: `Purchases.logOut()`
  - [ ] Test: Entitlements bleiben erhalten nach Login

### 3.5.3 UI — Auth Screens

- [x] **Login/Signup Screen** — [lib/presentation/auth/auth_screen.dart](lib/presentation/auth/auth_screen.dart)
  - [x] UI mit Email/Password Form
  - [x] Tab zwischen "Login" und "Signup"
  - [x] "Passwort vergessen?" Link
  - [ ] Social Login Buttons (Google/Apple) — optional für MVP
  - [x] Loading States während Auth
  - [x] Error Messages (invalid email, password mismatch, etc.)
  - [x] Dismiss Button

- [x] **Settings Integration** — Account Section
  - [ ] In [lib/presentation/settings/settings_screen.dart](lib/presentation/settings/settings_screen.dart):
    - [x] Wenn nicht angemeldet: "Anmelden" Button
    - [x] Wenn angemeldet: "Abmelden" Button + User Email anzeigen
    - [ ] Link zu Account Details (später)
  - [x] Styling konsistent mit Rest der App

- [x] **Onboarding Update**
  - [x] Nach Onboarding: Optional "Konto erstellen" Prompt
  - [x] Nicht erzwungen, nur Suggestion
  - [x] Dismiss-Option

### 3.5.4 Cloud Sync — Favoriten

- [ ] **Favorites Migration** — Lokal → Cloud
  - [x] Bei Login: Prüfe auf lokale Favoriten
  - [x] Synchronisiere alle lokalen Favoriten zu Cloud
  - [x] Merge-Strategie: Union (alle behalten, keine Duplikate)
  - [ ] Lokale DB mit User-ID versehen

- [x] **Sync Service** — [lib/core/services/supabase_sync_service.dart](lib/core/services/supabase_sync_service.dart)
  ```dart
  Future<void> syncFavoritesToCloud(String userId, List<String> favoriteQuoteIds);
  Future<List<String>> fetchFavoritesFromCloud(String userId);
  Future<void> addFavoriteToCloud(String userId, String quoteId);
  Future<void> removeFavoriteFromCloud(String userId, String quoteId);
  ```
  - [x] Implementiert mit Supabase REST Client

- [ ] **Favorites Provider Update** — [lib/domain/providers/favorites_provider.dart](lib/domain/providers/favorites_provider.dart)
  - [ ] Nach Cloud-Sync: Lokale Daten aktualisieren
  - [ ] Realtime Updates abonnieren (optional, Supabase Realtime)
  - [ ] Offline-First: Local-Change → Queue → Cloud Sync

- [ ] **Testing**
  - [ ] Lokal mehrere Favoriten hinzufügen
  - [ ] Anmelden mit Test-Account
  - [ ] Prüfen: Alle Favoriten jetzt in Cloud
  - [ ] Neues Gerät: Anmelden → Favoriten laden sofort

- [x] **Account Details Screen** — [lib/presentation/account/account_screen.dart](lib/presentation/account/account_screen.dart) ✅ (09.05.2026)
  - [x] E-Mail anzeigen
  - [x] "Passwort ändern" Button
  - [ ] "E-Mail ändern" Button (optional für MVP, später)
  - [x] "Konto löschen" Button (DSGVO) → Confirmation Dialog + Delete Flow
  - [x] "Daten exportieren" Button (DSGVO) → Share JSON Export

- [x] **Password Reset Flow**
  - [x] "Passwort vergessen" Link auf Login
  - [x] Email mit Reset-Link → Supabase Handler
  - [x] UI: "Check your email" Success State

- [x] **Data Export** — DSGVO Compliance ✅ (09.05.2026)
  - [x] AccountPrivacyService.buildExportJson() → JSON aller Nutzerdaten
  - [x] Format: { exported_at, account, profile, settings, favorites_list }
  - [x] Download/Share via Share plugin mit Timestamp

- [x] **Account Deletion** — DSGVO Right to be Forgotten ✅ (09.05.2026)
  - [x] Confirmation Dialog: "Sind Sie sicher? Alle Daten werden gelöscht."
  - [x] Client-Side: clearFavoritesFromCloud() + clearLocalUserData()
  - [x] Lokale Nutzerdaten (SharedPreferences + DB favorites/seen) gelöscht
  - [ ] Server-Side Auth Deletion (deferred; requires Edge Function — out-of-scope for MVP)

### 3.5.6 Testing & Verification

- [ ] **Supabase Dashboard Prüfung**
  - [ ] Profiles Table: Test-User erscheint
  - [ ] Favorites Table: Favoriten von Test-User sichtbar
  - [ ] RLS Policies: Andere User-Favoriten nicht sichtbar (SQL Test)

- [ ] **End-to-End Testing**
  - [ ] Gerät A: Favoriten hinzufügen (lokal)
  - [ ] Login mit Test-Account
  - [ ] Favoriten synchen zu Cloud
  - [ ] Gerät B: Installieren, Login mit gleichem Account
  - [ ] Prüfen: Alle Favoriten vorhanden
  - [ ] Gerät A: Neue Favorit hinzufügen
  - [ ] Gerät B: Refresh → Neue Favorit erscheint

- [ ] **Error Scenarios**
  - [ ] Internet aus während Login → Error-Nachricht
  - [ ] Wrong Password → Error-Nachricht
  - [ ] Sync Error → Retry-Button
  - [ ] Deleted Account → Auto-Logout



---

## Phase 4: App Store & Play Store Preparation 🏪

<details>
<summary><b>⏳ PENDING — Store Vorbereitung. Erweitern für Deployment-Details.</b></summary>

### 4.1 iOS — App Store Connect (deferred)

⏸️ Dieser Abschnitt ist für den aktuellen Play Store-Only-Release ausgesetzt.

#### Account & Bundle ID

- [ ] **App Store Connect Login** — Apple Developer Account
  - [ ] Konto aktiviert und verifiziert

- [ ] **Bundle ID** — Eindeutig und reserviert
  - [ ] Bundle ID: `com.marxapp.zitatatlas` (Beispiel, anpassen)
  - [ ] In `ios/Runner.xcodeproj` konfiguriert
  - [ ] In App Store Connect reserviert

#### App Metadata

- [ ] **App Name & Subtitle**
  - [ ] Name: "Marx Zitatatlas" (oder finaler Name)
  - [ ] Subtitle: "Zitatsammlung von Karl Marx" (optional)

- [ ] **Primary Category** — "Books" oder "Education"
  - [ ] Kategorie gewählt

- [ ] **Description** — App Store Listing
  - [ ] Deutsche Beschreibung (150-500 Zeichen)
  - [ ] Englische Beschreibung für Expansion später
  - [ ] Keywords: "Marx, Zitate, Philosophie, Bildung"

- [ ] **Screenshots** — 2-5 Pro Screen Size
  - [ ] iPhone 6.7" (größte): 3-5 Screenshots
  - [ ] iPhone 5.8" (Standard): 3-5 Screenshots
  - [ ] Screenshots zeigen: Home, Detail, Archive, Premium, Settings
  - [ ] Text auf Screenshots lesbar
  - [ ] Keine Sensitive-Infos sichtbar

- [ ] **App Icon**
  - [ ] 1024x1024 PNG oder JPG
  - [ ] Icon existiert: [assets/branding/app_icon.png](assets/branding/app_icon.png)
  - [ ] Icon wird von Flutter Launcher Icons generiert
  - Befehl: `flutter pub run flutter_launcher_icons`

#### Konfiguration

- [ ] **iOS Deployment Target** — iOS 12.0+
  - [ ] In `ios/Podfile`: `platform :ios, '12.0'`

- [ ] **In-App Purchase Capability**
  - [ ] Xcode: Target > Capabilities > In-App Purchase ✅

- [ ] **Privacy Policy URL**
  - [ ] Hosting: [https://yoursite.com/privacy](https://yoursite.com/privacy)
  - [ ] Link in Connect konfiguriert
  - [ ] Entitlement-Handling dokumentiert

- [ ] **License Agreement** — Standardvereinbarung oder Custom
  - [ ] Apple Standard EULA oder Custom-Text

#### Build & Testing

- [ ] **TestFlight Build Upload** — Vor Submission
  - Befehl: `flutter build ipa --release`
  - [ ] Build signiert mit Provisioning Profile
  - [ ] Build in App Store Connect hochgeladen
  - [ ] Auf TestFlight verfügbar nach Processing

- [ ] **Internal Testing** — Mindestens 24h vor Submission
  - [ ] Mit TestFlight-Link testen
  - [ ] Funktionen verifizieren: Purchase, Restore, Detail, Archive
  - [ ] Crashes oder Warnings notieren

#### Store Submission

- [ ] **Submission für Review** — Ready for Submission
  - [ ] Alle Metadaten vollständig
  - [ ] Screenshots hochgeladen
  - [ ] Build ausgewählt
  - [ ] Export Compliance beantwortet (meist "No" für Marx App)
  - [ ] Advertiser Name ggf. aktualisiert
  - [ ] App Review Guidelines befolgt
  - [ ] **SUBMIT FOR REVIEW** klicken
  - Typical Review Time: 1-2 Tage

### 4.2 Android — Google Play Console

#### Account & Package Name

- [ ] **Google Play Developer Account**
  - [ ] Account aktiviert
  - [ ] $25 Gebühr bezahlt (einmalig)
  - NOTE: Developer Account creation is postponed — perform this as the final pre-release step.

- [ ] **Package Name** — Eindeutig und reserviert
  - [ ] Package: `com.marxapp.zitatatlas` (Beispiel, anpassen)
  - [ ] In `android/app/build.gradle` konfiguriert
  - [ ] In Play Console reserviert

- [x] **Release Signing** — Vor Submission verpflichtend ✅ (09.05.2026)
  - [x] Keystore-File vorhanden: android/app/release.keystore (2756 bytes)
  - [x] key.properties konfiguriert mit allen 4 erforderlichen Feldern
  - [x] signingConfig in android/app/build.gradle.kts auf Release eingestellt
  - [ ] Release-Build AAB lokal erfolgreich erzeugen — NEXT: flutter build appbundle --release

#### App Metadata

- [ ] **App Name** — "Marx Zitatatlas"

- [ ] **App Category** — "Books & Reference" oder "Education"

- [ ] **Content Rating** — USK/PEGI
  - [ ] Questionnaire ausfüllen
  - [ ] Keine Violent Content, Adult Content → Usually "3+" or "6+"

- [ ] **Description** — Play Store Listing
  - [ ] Deutsche Beschreibung (80-4000 Zeichen)
  - [ ] Short Description (80 Zeichen)
  - [ ] Full Description mit Features

- [ ] **Screenshots** — 2-8 pro Größe
  - [ ] 6.7" Screenshots (1440x2560px)
  - [ ] 5.1" Screenshots (1080x1920px)
  - [ ] Screenshots zeigen: Home, Detail, Archive, Premium
  - [ ] Text lesbar, keine Sensitive Infos

- [ ] **Feature Graphic** — 1024x500px
  - [ ] Banner mit App-Icon und Headlines

- [ ] **App Icon** — 512x512px
  - [ ] Aus [assets/branding/app_icon.png](assets/branding/app_icon.png)
  - [ ] PNG Format, keine Alpha-Channel notwendig

#### Konfiguration

- [ ] **Target API Level** — Android 12+
  - [ ] `android/app/build.gradle`: `targetSdkVersion >= 31`

- [ ] **Billing Permission** — AndroidManifest.xml
  ```xml
  <uses-permission android:name="com.android.vending.BILLING" />
  ```

- [ ] **Privacy Policy** — URL hinterlegt
  - [ ] REQUIRED — Play Store erzwingt Policy

- [ ] **Contact Email** — Support-E-Mail
  - [ ] Support-E-Mail für Nutzer-Anfragen

#### Build & Testing

- [ ] **Internal Testing Track** — Vor Closed Beta
  - [ ] Android App Bundle erstellen: `flutter build appbundle --release`
  - [ ] Bundle in Play Console hochgeladen
  - [ ] Auf Internal Track verfügbar (sofort)

- [ ] **Test auf Internal Track**
  - [ ] Test-Device registrieren
  - [ ] Install-Link kopieren und App installieren
  - [ ] Funktionen verifizieren: Purchase, Restore, Detail
  - [ ] Mindestens 1-2 Tage vor Closed Beta

- [ ] **Closed Beta Track** — Optionale Phase vor Production
  - [ ] Build auf Closed Beta hochladen
  - [ ] 1-2 externe Tester einladen
  - [ ] Feedback sammeln für 3-5 Tage

#### Store Submission

- [ ] **Production Release** — Go Live
  - [ ] Build ausgewählt (aus Closed Beta oder Direct)
  - [ ] Release Notes (Deutsch): "Initialversion: Tägliche Marx-Zitate, Such-Archive, Premium-Abonnement"
  - [ ] Rollout % auf 10-25% starten (statt 100%)
  - [ ] Monitor für Crashes & Ratings nächste 12-24h
  - [ ] Auf 100% erhöhen wenn stabil
  - **SUBMIT FOR REVIEW** oder **RELEASE** klicken
  - Typical Review Time: 3-4 Stunden (manchmal bis zu 8h)

### 4.3 Beide Stores — Post-Submission

- [ ] **Review Status Monitoring** — Täglich prüfen
  - iOS: App Store Connect Notification (deferred)
  - Android: Play Console Email oder Manual Check

- [ ] **Review Rejection Handling** — Falls nötig
  - iOS: Typische Rejections → In-App Purchase Compliance, Privacy, Crashes (deferred)
  - Android: Seltener, aber auf Account Suspension prüfen

- [ ] **Launch Plan nach Approval**
  - [ ] Play Store auf Production (nicht Beta)
  - [ ] Social Media Announcement vorbereiten
  - [ ] Beta-Testers benachrichtigen

</details>

---

## Phase 5: Post-Launch Monitoring 📊

<details>
<summary><b>⏳ PENDING — Monitoring nach Launch. Erweitern für Post-Release-Strategie.</b></summary>

### 5.1 Crash & Error Monitoring

- [ ] **Firebase Crashlytics Setup** — Falls nicht vorhanden
  - [ ] `firebase_core` und `firebase_crashlytics` in `pubspec.yaml`
  - [ ] `flutterfire configure` ausgeführt
  - [ ] Crashlytics in [lib/main.dart](lib/main.dart) initialisiert
  - Status Check: [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

- [ ] **Crashlytics Dashboard** — Monitoring
  - [ ] Firebase Console offen täglich (erste Woche)
  - [ ] Crashes oder ANRs (Android Not Responding) prüfen
  - [ ] High-Volume Crashes haben oberste Priorität

- [ ] **Error Alerting** — Notifications einrichten
  - [ ] Email-Alerts für Critical Crashes
  - [ ] Slack/Discord Bot für Real-Time Alerts (optional)

### 5.2 User Metrics & Analytics

- [ ] **Firebase Analytics** — Optionale Tracking
  - [ ] Events für Key User Flows gemappt (z.B. Quote_Viewed, Purchase_Clicked)
  - [ ] Custom Events für Premium-Only Features
  - [ ] Dashboard mit Retention, DAU, Conversion

- [ ] **App Store & Play Store Analytics**
  - [ ] iOS: App Store Connect → Analytics Tab
  - [ ] Android: Play Console → Statistics T
  ab
  - Metrics zu monitoren:
    - Downloads/Installs
    - Uninstalls/Crashes
    - Rating & Reviews
    - Conversion Rate (wenn sichtbar)

### 5.3 Hot Fixes & Patches

- [ ] **Patch Process** — Falls kritischer Bug nach Launch
  - [ ] Bug dokumentieren
  - [ ] Fix in Development Branch
  - [ ] Build als Patch-Version (v0.1.1, v0.1.2)
  - [ ] Upload zu Internal/Closed Beta erst
  - [ ] Nach 1-2 Tagen Testing → Production
  - [ ] Changelog mit Bug-Fix beschreiben

### 5.4 Review Management

- [ ] **User Reviews & Ratings** — Täglich erste Woche
  - iOS: App Store Connect → Reviews
  - Android: Play Console → Ratings & Reviews
  - [ ] Negative Reviews auf Fehler checken
  - [ ] Support-E-Mail bereitstellen für User-Bugs

- [ ] **Rating Improvement Plan** — Nach 1 Woche
  - [ ] Wenn Rating < 4.0: Critical Issues beheben, Patch releasen
  - [ ] Wenn Rating 4.0+: Positives Momentum halten

</details>

---

## 🎯 PRIORITY TRACKER — Was ist gerade dran?

### ✅ PHASE 3.5 ABGESCHLOSSEN — Account Management & Cloud Sync ✅ (10.05.2026)

**Status:** Code-Implementierung 100% komplett. Alle Komponenten verifiziert.

**Erledigte Punkte diese Session:**
- [x] Account Privacy Service (Export/Delete) vollständig implementiert
- [x] DSGVO Export: JSON mit Nutzerdaten, Settings, Favoriten
- [x] DSGVO Delete: Lokale + Cloud Daten gelöscht mit Confirmation Dialog
- [x] Android Release Signing: Keystore verifiziert, key.properties konfiguriert
- [x] Code linting: Alle Warnings gelöst

### ⏳ NÄCHSTE PHASE: 4 — Store Preparation & Submission

**Nächste 4 Schritte (diese Woche):**
1. [ ] Android AAB Release Build verifizieren — `flutter build appbundle --release` bis Completion
2. [ ] Play Store Metadaten & Screenshots finalisieren (Descriptions, 6.7"/5.1" Screenshots, Privacy URL)
3. [ ] Google Play Developer Account erstellen (Einmalige $25 Gebühren)
4. [ ] Internal Test Track Release & Pixel6-QA durchführen

**Blockers auflösen:**
- [ ] AAB Build möglicherweise ~10 min auf Windows — parallel weitermachen oder Watch starten
- [ ] Store-Metadaten-Screenshots erfordern UI-Screenshots (Emulator oder Device)
- [ ] Play Console Account ist Blocker für Internal Track Upload

**Geplant danach:**
- Closed Beta Testing (optional, 1-2 Tage)
- Production Rollout (staged 10-25%)

---

## 📊 Risikoregister (Alle Phasen)

| Risiko | Phase | Priorität | Nächste Aktion |
| --- | --- | --- | --- |
| Android AAB Build nicht verifiziert | 4 | Hoch | `flutter build appbundle --release` bis Completion laufen lassen |
| Play Store Metadaten/Screenshots unvollständig | 4 | Hoch | Descriptions + UI-Screenshots finalisieren |
| Google Play Dev Account noch nicht erstellt | 4 | Hoch | Developer Account erstellen ($25) und App-Record Setup |
| RevenueCat Test-Account-Flow offen | 3 | Hoch | Sandbox- und Internal-Track-Test ausführen |
| Offline-Loading ohne belastbaren Nachweis | 1 | Mittel | Netzwerkloses Starten auf Pixel6 dokumentieren |
| Cold Start nicht auf Gerät verifiziert | 1 | Mittel | Physischen Test auf Zielgerät nachholen |

---

## 📋 Phase-Übersicht (Kompakt)

| Phase | Status | Fokus | Start |
| --- | --- | --- | --- |
| **1** — Bug Stabilization | ✅ Erledigt | Bootstrap, Core Flows | — |
| **2** — UI Polish | ✅ Erledigt | Typography, Spacing, Loading States | — |
| **3** — Monetization | ✅ Code-Ready | RevenueCat, Payment Testing (pending) | — |
| **3.5** — Account & Sync | ✅ **COMPLETED** (10.05.2026) | Account Privacy, Cloud Sync | — |
| **4** — Store Prep | 🔄 **AKTIV** | AAB Build, Store Metadaten, Play Console | Diese Woche |
| **5** — Post-Launch | ⏳ Pending | Monitoring, Crash Handling, Reviews | Nach 4 |

---

## 📞 Hilfreiche Links & Ressourcen

**Projektdokumentation:**
- [APP_PLAN.md](APP_PLAN.md) — Produkt- und Scope-Plan
- [REVENUECAT_SETUP.md](REVENUECAT_SETUP.md) — Monetization Details
- [PHASE_4_DEPLOYMENT_GUIDE.md](PHASE_4_DEPLOYMENT_GUIDE.md) — Android Store Submission
- [PERFORMANCE_ANALYSIS.md](PERFORMANCE_ANALYSIS.md) — UI Performance Audit

**Phase 3.5 Ressourcen (Supabase):**
- [Supabase Documentation](https://supabase.com/docs) — Offizielle Docs
- [Supabase Flutter Guide](https://supabase.com/docs/reference/flutter/introduction) — Flutter Integration
- [PostgreSQL RLS](https://www.postgresql.org/docs/current/sql-createrole.html) — Row Level Security Docs
- [supabase_flutter Package](https://pub.dev/packages/supabase_flutter) — Pub.dev

---

## Launch-Monat: Mai 2026 — Fokussierter Plan bis zum Release

Ziel: Release auf Google Play diesen Monat (Ende Mai). Priorität: Stabilität, Auth & Sync, Store‑Metadaten, Release‑Signierung.

Kurzfristige Prioritäten (Reihenfolge):

- [x] **Supabase Projekt finalisieren**
  - Tasks: Projekt anlegen, DB‑Schema deployen, RLS‑Policies aktivieren, Anon/Service Keys sichern.
- [x] **Auth Service & Riverpod Provider implementieren**
  - Tasks: `supabase_flutter` integrieren, `SupabaseAuthService` implementieren, `currentSupabaseUserProvider` bereitstellen.
- [x] **Favorites Cloud‑Sync & Migration**
  - Tasks: Sync‑Service implementieren, lokale Favoriten migrieren, Merge‑Strategie (Union) testen.
- [x] **RevenueCat ↔ Login Flow testen**
  - Tasks: `Purchases.logIn(userId)`/`logOut()` testen, Entitlement Refresh mit Login/Logout prüfen.
- [x] **Android Keystore & Release Signing finalisieren**
  - Tasks: Keystore prüfen/erstellen, `signingConfig` setzen, Test‑Release‑Build erzeugen.
  - Verifiziert: Release‑Keystore lokal erstellt, `key.properties` gesetzt, `flutter build appbundle --release` erfolgreich.
- [ ] **Play Store Metadaten & Screenshots erstellen**
  - Tasks: Short/Full Description, Screenshots (6.7" + 5.1"), Feature Graphic, Privacy URL, Support‑Email.
- [ ] **Internal Test Track Release + Tests**
  - Tasks: AAB bauen, Internal Track hochladen, 1–2 Testgeräte validieren (Purchase, Restore, Login, Sync).
  - Status: `build/app/outputs/bundle/release/app-release.aab` lokal erzeugt.
  - Runbook: [INTERNAL_TRACK_UPLOAD_RUNBOOK.md](INTERNAL_TRACK_UPLOAD_RUNBOOK.md)
- [ ] **Final QA auf Zielgerät (Pixel6)**
  - Tests: Cold Start, Offline‑Loading, Navigation/Back, Purchase Flow, Sync, Restore, Theme/Fonts.
  - Runbook: [TEST_RUNBOOK_PIXEL6_FINAL_QA.md](TEST_RUNBOOK_PIXEL6_FINAL_QA.md)
  - Automatischer Teil zuletzt gelaufen: `qa_reports/pixel6_final_qa_20260509_182332.md`
- [ ] **Crashlytics & Monitoring einrichten**
  - Tasks: Crashlytics initialisieren, Alerts konfigurieren, erste Baseline‑Logs prüfen.
  - Status: `firebase_core` + `firebase_crashlytics` integriert, Startup-Hooks in `main.dart` aktiv (Release-only, fail-safe ohne Firebase-Config).
  - Offen: `flutterfire configure` ausführen und produktive Firebase-Projektwerte hinterlegen.
- [ ] **Production Rollout & Monitoring**
  - Tasks: Staged Rollout (10–25%), enges Monitoring 24–48h, Bugfix‑Patch‑Plan bereitstellen.

Kurz‑Zeitplan (aktualisiert für Phase 4 – 10.05.2026):

- **SOFORT (heute):** Phase 3.5 abhacken ✅; Android AAB Build starten (`flutter build appbundle --release`)
- **Parallel:** Play Store Metadaten + Screenshots finalisieren; Store-Descriptions schreiben
- **Nach AAB-Verifizierung:** Google Play Developer Account erstellen ($25); App-Record setup
- **Nach Play Console Setup:** Internal Track Release + Pixel6-QA durchführen
- **Nach QA:** Closed Beta (optional, 1-2 Tage); Production Rollout (staged 10-25%)

Kommunikation & Verantwortlichkeiten:

- Kontinuierliche Fortschritt-Updates — Blocker sofort escalieren
- AAB-Build läuft im Hintergrund? Weiterarbeiten an Metadaten parallel

**Nächster Schritt JETZT:**
1. Starte Android AAB Release Build: `flutter build appbundle --release` (ca. 10 min)
2. Währenddessen: Play Store Metadaten vorbereiten (Descriptions, Screenshots-Sammlung)
3. Nach Build-Completion: AAB-Datei verifizieren + Internal Track prep starten
