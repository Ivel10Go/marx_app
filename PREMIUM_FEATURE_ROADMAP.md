# Premium Feature Roadmap (Zitate App)

## Ziel
Premium soll sich wie ein echter Lernvorteil anfuehlen, nicht wie ein Paywall-Trick.

## Leitprinzipien
- Free bleibt voll nutzbar und sinnvoll.
- Premium verbessert Tiefe, Komfort und Kontinuitaet.
- Jede Premium-Funktion muss im Alltag spuerbaren Mehrwert liefern.

## Neue Premium-Features (Vorschlag)

### 1) Deep Dive Modus (Pro)
- Was: Zusätzliche analytische Ebene pro Zitat (Begriffe, Widerspruchspaare, heutige Relevanz).
- UX: Eigener Abschnitt auf der Detailseite unterhalb der Kurzerklaerung.
- KPI: Zeit auf Detailseite, Scrolltiefe.

### 2) Lernpfade / Serien (Pro)
- Was: Kuratierte 7-14 Tage Pfade (z. B. Arbeit, Entfremdung, Staat).
- UX: Neue Route `/learning-paths` mit Tagesfortschritt.
- KPI: 7-Tage-Retention, Abschlussrate pro Pfad.

### 3) Smart Reminder 2.0 (Pro)
- Was: Adaptive Benachrichtigungszeit basierend auf Nutzungsfenster + Streak-Risiko.
- UX: In Einstellungen mit "Empfohlen" + manueller Override.
- KPI: Reminder-Open-Rate, Streak-Verlustreduktion.

### 4) Offline Plus (Pro)
- Was: Lokale Caches fuer komplette Lernserien und Favoriten-Exportdaten.
- UX: Toggle "Serie offline speichern" in Pfad-Detail.
- KPI: Nutzung ohne Netz, Crash-Rate bei Offline.

### 5) Pro Notizen & Markierungen
- Was: Eigene Notizen pro Zitat + Highlight von Schluesselpassagen.
- UX: Notiz-Icon in Detailansicht, markdown-lite Textfeld.
- KPI: Wiederkehrrate auf bereits notierte Zitate.

### 6) Audio-Erklaerung (Pro)
- Was: TTS-basierte Vorleseansicht fuer Kurzerklaerung + Deep Dive.
- UX: "Anhoeren" Button in Detailscreen.
- KPI: Audio-Starts, durchschnittliche Hoerdauer.

### 7) Wissenschecks (Pro)
- Was: Kleine adaptive Quizfragen nach 3-5 gelesenen Zitaten.
- UX: Leichte Multiple-Choice Cards, sofortiges Feedback.
- KPI: Quiz Completion, Learning-Session-Laenge.

### 8) Personalisierte Wochenausgabe (Pro)
- Was: Woechentliche Zusammenfassung mit Top-Themen, Streak, Empfehlungen.
- UX: Sonntagskarte + optional PDF Export.
- KPI: Wochen-Engagement, Conversion von aktiven Nutzern.

## Feature-Tiers
- Free:
  - Tageszitat/Facts
  - Favoriten
  - Basis-Erklaerung
  - Standard-Erinnerung
- Pro:
  - Deep Dive
  - Lernpfade
  - Smart Reminder 2.0
  - Notizen/Highlights
  - Audio-Erklaerung
  - Wissenschecks
  - Wochenausgabe

## Rollout-Empfehlung (in Etappen)
1. Jetzt (1-2 Wochen):
- Deep Dive finalisieren
- Lernpfade v1
- Smart Reminder 2.0 verfeinern

2. Danach (2-4 Wochen):
- Notizen/Highlights
- Audio-Erklaerung

3. Spaeter (4-8 Wochen):
- Wissenschecks
- Wochenausgabe

## Technische Hinweise
- RevenueCat Entitlement bleibt `zitate_app_pro`.
- Alle Gates ueber `isProProvider`.
- Features serverseitig konfigurierbar halten (Remote Config/Feature Flags), um A/B Tests zu erlauben.

## Sofort umsetzbare Tickets
- Ticket 1: Neue Route `learning-paths` + Dummy-Daten + Pro-Gate.
- Ticket 2: `QuoteNote` Modell + lokale Persistenz (Drift).
- Ticket 3: Smart Reminder Heuristik um Nutzungszeitfenster erweitern.
- Ticket 4: Telemetrie Events fuer Premium-Funnel (view_paywall, start_purchase, unlock_pro).
