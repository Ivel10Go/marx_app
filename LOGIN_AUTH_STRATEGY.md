# Login / Auth Strategie (Zitate App)

## Zielbild
Ein optionales Konto-System: App bleibt ohne Login nutzbar, aber Sync-, Backup- und Community-nahe Features nutzen Account.

## Warum optionaler Login statt Login-Pflicht
- Weniger Friktion im Erststart.
- Bessere Conversion in der Onboarding-Phase.
- Premium kann sofort gekauft werden, Konto folgt bei Bedarf.

## Empfohlene Architektur

### Auth Stack
- Provider: Supabase Auth (Email/Passwort + OAuth Apple/Google)
- Session: Supabase SDK + persistente Tokens
- Daten: Supabase Postgres fuer cloud-syncte Nutzerdaten

Alternative:
- Firebase Auth + Firestore, falls Team bereits Firebase-first ist.

## Nutzer-Identitaeten

### 1) Anonymous App User (default)
- Beim ersten Start: generiere lokale `anonymousUserId` (UUID).
- Alle lokalen Daten (Favoriten, Notizen, Streak) an diese ID binden.

### 2) Registered User
- Nach Login/Signup: `accountUserId` vorhanden.
- Lokale Daten migrieren (merge) von `anonymousUserId` auf `accountUserId`.

## RevenueCat + Login sauber verbinden
- Ohne Login: RevenueCat mit anonymer ID betreiben.
- Bei Login: `Purchases.logIn(accountUserId)` aufrufen.
- Bei Logout: `Purchases.logOut()` und neue anonyme Session erzeugen.
- Wichtig: Merge/Transfer-Strategie testen (Sandbox), damit Entitlements erhalten bleiben.

## Datenmodell (Cloud)
- `profiles` (id, display_name, locale, created_at)
- `user_favorites` (user_id, quote_id, created_at)
- `user_notes` (user_id, quote_id, note_text, updated_at)
- `user_streaks` (user_id, streak_count, last_seen_date)
- `user_settings` (user_id, notification_time, mode, language)

## Security / Compliance
- Row Level Security (RLS) aktivieren.
- Nur eigene Datensaetze lesbar/schreibbar.
- Privacy Policy + Data Deletion Route bereitstellen.
- DSGVO: Export/Loeschung pro Nutzer ermoglichen.

## UX Flow (Empfohlen)
1. Onboarding ohne Pflicht-Login.
2. Paywall/Pro-Kauf normal verfuegbar.
3. Kontextuelles Login-Prompt bei Cloud-Features:
- "Auf allen Geraeten synchronisieren"
- "Notizen sichern"
4. Nach Login: Datenzusammenfuehrung bestaetigen.

## Implementierungsplan

### Phase 1 (MVP, 1-2 Wochen)
- Auth UI: Email + Google/Apple
- Session Handling
- RevenueCat `logIn/logOut` Flow

### Phase 2 (2-3 Wochen)
- Favorites + Settings Sync
- Konfliktstrategie (latest-wins oder merge rules)

### Phase 3 (3-5 Wochen)
- Notizen-Sync
- Account-Center (E-Mail, Passwort, Konto loeschen)

## Konfliktstrategie beim Sync
- Favoriten: set-union (nichts verlieren)
- Settings: server-preferred mit local fallback
- Streak: max(streak_local, streak_cloud)
- Notizen: latest update timestamp gewinnt

## Risiken und Gegenmassnahmen
- Risiko: Entitlement-Verlust bei Login-Wechsel
- Massnahme: RevenueCat login/logout in Integrationstests absichern

- Risiko: Datenkonflikte bei Offline/Online Wechsel
- Massnahme: klare Merge-Regeln + Telemetrie fuer Sync-Fehler

## Sofortige technische To-dos
- `AuthService` Interface im Core anlegen
- `currentUserProvider` + `isAuthenticatedProvider`
- `PurchasesService` um `logIn`/`logOut` Wrapper erweitern
- Account-Bereich in Settings: "Anmelden", "Konto verwalten", "Abmelden"
