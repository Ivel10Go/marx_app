# AGENTS

Dieses Dokument hilft AI Coding Agents, in diesem Projekt schnell und sicher zu arbeiten.

## Projektüberblick

- Stack: Flutter, Riverpod, Drift (SQLite), GoRouter, SharedPreferences, RevenueCat, Workmanager.
- Zielplattformen: Android, iOS, Web, Desktop (siehe Flutter-Standardordner).
- Primäre App-Struktur liegt unter lib/ mit Trennung in core, data, domain, presentation, widgets.

## Schnellstart-Kommandos

- Abhängigkeiten installieren: flutter pub get
- App auf lokalem Gerät starten: flutter run -d pixel6
- Statische Analyse: flutter analyze
- Code-Generierung (Drift, Riverpod): flutter pub run build_runner build

Hinweis: Es gibt aktuell keine gepflegte Test-Suite im Repository. Wenn du neue Logik einführst, ergänze gezielte Tests in test/.

## Architekturgrenzen

- core/: Bootstrap, Router, Services, Theme, app-weite Konstanten.
- data/: Persistenz und Repositories (Drift-DB, DAOs, Modelle).
- domain/: Domänenlogik und Provider-nahe Orchestrierung.
- presentation/: Screens und UI-Flows.
- widgets/: Wiederverwendbare UI-Bausteine.

Behalte diese Grenzen bei. Vermeide direkte UI-Abhängigkeiten in data/ und domain/.

## Kritische Fallstricke

- Isolates mit compute:
  - Keine Platform-Channel-Plugins in compute-Callbacks aufrufen.
  - SharedPreferences und ähnliche Werte im Main-Isolate lesen und nur primitive Daten in compute übergeben.

- Timezone-Import:
  - Für Notifications nur package:timezone/data/latest.dart verwenden.
  - latest_all.dart kann unnötig Speicherverbrauch und Build-Probleme verursachen.

- Drift-Indexe:
  - CREATE INDEX nie in Table.customConstraints eintragen.
  - Indexe ausschließlich in Migrationen per customStatement erstellen.

## Änderungsrichtlinien

- Kleine, fokussierte Änderungen statt großer Refactors.
- Bestehende Patterns in benachbarten Dateien übernehmen.
- Bei Schema- oder Storage-Änderungen immer Migrationspfad prüfen.
- Bei Startup- oder Performance-Änderungen auf nicht-blockierende Initialisierung achten.
- Bei Monetization-Änderungen Entitlement-Checks konsistent halten.

## Wichtige Einstiegspunkte

- App-Start und Bootstrap: lib/main.dart, lib/core/bootstrap/app_bootstrap.dart
- Routing: lib/core/router/
- Datenbank: lib/data/database/app_database.dart, lib/data/database/tables.dart
- Home-Flow: lib/presentation/home/
- Paywall und Käufe: lib/presentation/paywall/, lib/core/services/purchases_service.dart
- Notifications: lib/core/services/notification_service.dart

## Verlinkte Projektdokumentation

Nutze die bestehenden Dokus als Quelle, statt Inhalte hier zu duplizieren:

- Produkt- und Scope-Plan: APP_PLAN.md
- Performance-Analyse: PERFORMANCE_ANALYSIS.md
- Performance-Optimierungen: PERFORMANCE_OPTIMIZATION.md
- RevenueCat Setup: REVENUECAT_SETUP.md
- RevenueCat Integration: REVENUECAT_INTEGRATION.md
- Firebase Setup: FIREBASE_SETUP.md
- Monetization-Optionen: MONETIZATION_OPTIONS_RESEARCH.md
- Paywall UI-Spezifikation: PAYWALL_STYLE_SPEC.md
- Premium-Roadmap: PREMIUM_FEATURE_ROADMAP.md

## Für zukünftige Agent-Customizations

Sinnvolle nächste Schritte:

- Eine Datei-instruktion für Drift-Migrationen und Datenbankänderungen.
- Eine Datei-instruktion für Riverpod- und Widget-Performance-Muster in presentation/.
- Ein Skill für wiederkehrende Content-Datenpflege in assets/ und tools/.