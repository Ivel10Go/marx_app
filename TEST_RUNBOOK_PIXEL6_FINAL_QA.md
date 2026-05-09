# Final QA Runbook (Pixel6)

Stand: 2026-05-09 18:12:44
Plattform: Android (Play Store First)
Build-Artefakt: build/app/outputs/bundle/release/app-release.aab
SHA256: 14B3D7EC5EE777E0D9CABA1BF96663186FA0A67CC07914E04551FB461C266AC6

## Ziel

Dieses Runbook dokumentiert den finalen, reproduzierbaren Pixel6-Check vor dem Internal-Track-Upload.

## Voraussetzungen

- AAB ist lokal vorhanden.
- Testkonto fuer Google Play Billing ist verfuegbar.
- Geraet: Pixel6 mit stabiler Internetverbindung.

## Testprotokoll

- Datum:
- Geraet:
- Build/Commit:
- Tester:
- Ergebnis:
- Offene Punkte:

## Block A: Install & Start

- [ ] App sauber installieren.
- [ ] Cold Start ohne Crash.
- [ ] Home-Content sichtbar in <= 3s.
- [ ] App-Neustart: letzter Zustand bleibt stabil.

## Block B: Offline Robustheit

- [ ] Flugmodus ein, App starten.
- [ ] Erwartung: kein Crash, sinnvoller Fallback/Fehlertext.
- [ ] Retry nach Netz an: Content laedt wieder.

## Block C: Navigation

- [ ] Alle Haupttabs oeffnen: Home, Archive, Favorites, Thinkers, Settings.
- [ ] Quote Detail aufrufen und zurueck.
- [ ] Android Back-Button: korrektes Zurueckverhalten.

## Block D: Premium & Billing

- [ ] Paywall oeffnet ohne Fehler.
- [ ] Offerings laden sichtbar.
- [ ] Kaufversuch mit Testkonto.
- [ ] Nach Kauf: Pro-Status sichtbar.
- [ ] Restore Purchases pruefen.
- [ ] Purchase Cancel Flow pruefen (kein Crash, klare Meldung).

## Block E: Account & Sync

- [ ] Login mit Supabase klappt.
- [ ] RevenueCat Login/Logout bleibt konsistent.
- [ ] Favorit lokal setzen, Sync triggern.
- [ ] Nach Neustart/Fetch bleibt Favorit erhalten.

## Block F: Settings & Notifications

- [ ] Wichtige Settings speichern persistiert.
- [ ] Notification Toggle und Zeitwahl funktionieren.

## Abnahmekriterien

- [ ] Keine Blocker-Crashes.
- [ ] Keine Dead Ends in Navigation.
- [ ] Billing Kernflows bestehen.
- [ ] Auth/Sync Kernflows bestehen.

## Ergebnis

- Go fuer Internal Track: [ ] Ja [ ] Nein
- Begruendung:
- Folgeaufgaben:
