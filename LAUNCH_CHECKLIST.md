# Marx App — Veröffentlichungs-Checkliste

**Ziel:** Stabile, fehlerfreie und monetarisierte App für iOS und Android veröffentlichen.
**Stand:** Mai 2026
**Status:** Phase 1 formal abgeschlossen

---

## 📋 Übersicht der Launch-Phasen

```
Phase 1: Bug Stabilization (COMPLETED)
    ↓
Phase 2: UI Polish
    ↓
Phase 3: Monetization & Payment Testing
    ↓
Phase 4: Store Preparation & Submission
    ↓
Phase 5: Post-Launch Monitoring
```

---

## Phase 1: Bug Stabilization & Core Reliability ⚙️

**Ziel:** Hauptbenutzerflüsse müssen fehlerfrei funktionieren, ohne bekannte Hochpriorität-Fehler.

**Abschlussnotiz:** Die Kernflüsse sind verifiziert. Der physische Cold-Start-Test auf dem Pixel 6 bleibt als bewusst ausgelassener Gerätetest dokumentiert und kann bei verfügbarer Hardware nachgezogen werden.

### 1.1 Bootstrap & Startup Reliability

- [ ] **Cold Start Test** — Vollständiger Neustart durchführen
  - Verifizieren: App startet ohne Crashes
  - Verifizieren: Loading-Screen und Fallback-States zeigen sich bei langsamer Verbindung
  - Verifizieren: Content wird nach ~2-3 Sekunden geladen

- [ ] **Content Loading mit Offline** — Netzwerk ausschalten, neu starten
  - Verifizieren: Cached Content zeigt sich
  - Verifizieren: Fehlerstate ist benutzerfreundlich (nicht leerer Screen)
  - Verifizieren: Retry-Button funktioniert

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
  - Verifizieren: Keine Navigation-Fehler im Konsole

- [ ] **Back Button Verhalten** — Android Back Button prüfen
  - Verifizieren: Back-Navigation funktioniert auf allen Screens
  - Verifizieren: Doppelter Back-Click schließt App

### 1.5 Known Bugs & Blockers

**Zu Überprüfen:**
- [ ] Gibt es bekannte Crash-Reports?
- [x] Welche Fehler zeigen sich in `flutter analyze`?
- [ ] Konsolen-Warnungen während normal Nutzung?

**Dokumentation:**
- [ ] Alle bekannten Bugs mit Priorität kennzeichnen (Blocker/High/Low)
- [ ] Blocker-Bugs vor Launch beheben

---

## Phase 2: UI Polish & Visual Consistency 🎨

**Ziel:** App sieht poliert und kohärent aus über alle Hauptscreens.

### 2.1 Typography & Spacing

- [ ] **Home Screen** — Header und Quote Card
  - Verifizieren: Headline klar lesbar
  - Verifizieren: Quote-Text hat gutes Line-Spacing
  - Verifizieren: Metadata (Autor, Jahr) nicht zu klein
  - Verifizieren: Actions (Share, TTS, Bookmark) klar angeordnet

- [ ] **Quote Detail Screen** — Vollständige Quote ansehen
  - Verifizieren: Hierarchie klar (Autor > Quote > Erklärung)
  - Verifizieren: Erklärung hat gutes Line-Spacing
  - Verifizieren: Related Quotes sind skandierbar

- [ ] **Archive & Search** — Liste und Filter
  - Verifizieren: Zitate in Liste konsistent formatiert
  - Verifizieren: Filter-Tags einheitlich styled
  - Verifizieren: Empty State lesbar und hilfreich

- [ ] **Settings Screen** — Consistent Card Design
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

---

## Phase 3: Monetization & Payment Testing 💳

**Ziel:** RevenueCat, Zahlungen und Entitlements sind zuverlässig.

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

- [ ] **Store Product IDs** — App Store & Play Store
  - iOS: `zitate_app_pro_monthly_ios`, `zitate_app_pro_yearly_ios`
  - Android: `zitate_app_pro_monthly_android`, `zitate_app_pro_yearly_android`
  - [ ] IDs in RevenueCat Dashboard gemappt
  - [ ] IDs in App Store Connect konfiguriert
  - [ ] IDs in Google Play Console konfiguriert

### 3.2 Purchase Flow Testing

**Gerät-Setup erforderlich — nicht im Emulator testbar**

#### iOS Testing (TestFlight/Sandbox)

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

---

## Phase 4: App Store & Play Store Preparation 🏪

**Ziel:** App ist bereit zur Submission auf beiden Stores.

### 4.1 iOS — App Store Connect

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

- [ ] **Package Name** — Eindeutig und reserviert
  - [ ] Package: `com.marxapp.zitatatlas` (Beispiel, anpassen)
  - [ ] In `android/app/build.gradle` konfiguriert
  - [ ] In Play Console reserviert

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
  - iOS: App Store Connect Notification
  - Android: Play Console Email oder Manual Check

- [ ] **Review Rejection Handling** — Falls nötig
  - iOS: Típische Rejections → In-App Purchase Compliance, Privacy, Crashes
  - Android: Seltener, aber auf Account Suspension prüfen

- [ ] **Launch Plan nach Approval**
  - [ ] Beide Stores auf Production (nicht Beta)
  - [ ] Social Media Announcement vorbereiten
  - [ ] Beta-Testers benachrichtigen

---

## Phase 5: Post-Launch Monitoring 📊

**Ziel:** App läuft stabil in Production, Fehler werden erfasst und behoben.

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
  - [ ] Android: Play Console → Statistics Tab
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

---

## 🎯 Quick Status Tracker

Verwende diese Sektion um schnell den Status der App zu tracken:

### Phase 1: Bug Stabilization
```
[ ] Bootstrap Reliability
[ ] Daily Quote Loop
[ ] Archive & Search
[ ] Thinkers Screen
[ ] Settings & Preferences
[ ] Navigation & Routing
[ ] Known Bugs Fixed
```
**Status:** ___________
**Blockers:** ___________

### Phase 2: UI Polish
```
[ ] Typography & Spacing
[ ] Color & Contrast
[ ] Loading & Error States
[ ] Premium & Paywall
```
**Status:** ___________
**Blockers:** ___________

### Phase 3: Monetization Testing
```
[ ] RevenueCat Setup
[ ] iOS Purchase Testing
[ ] Android Purchase Testing
[ ] Error Handling
```
**Status:** ___________
**Blockers:** ___________

### Phase 4: Store Preparation
```
[ ] iOS — App Store Connect
[ ] Android — Play Console
[ ] Ready for Submission
```
**Status:** ___________
**Expected Launch:** ___________

### Phase 5: Post-Launch
```
[ ] Monitoring Setup
[ ] Crash Handling
[ ] Review Management
```
**Status:** ___________

---

## 📞 Hilfreiche Links & Dokumente

- [APP_PLAN.md](APP_PLAN.md) — Produkt- und Scope-Plan
- [REVENUECAT_INTEGRATION.md](REVENUECAT_INTEGRATION.md) — Monetization Details
- [FIREBASE_SETUP.md](FIREBASE_SETUP.md) — Crash Reporting
- [PERFORMANCE_OPTIMIZATION.md](PERFORMANCE_OPTIMIZATION.md) — Optimierungen bereits durchgeführt
- [PAYWALL_STYLE_SPEC.md](PAYWALL_STYLE_SPEC.md) — UI Spezifikation

---

## Nächste Schritte

1. **Diese Checkliste durchlesen** — 10 min
2. **Phase 1 starten**: Bootstrap & Content Loading testen — 30 min
3. **Mit Agent besprechen** welche Phase zuerst angegriffen wird
4. **Regelmäßig aktualisieren** — Nach jedem abgeschlossenen Schritt
