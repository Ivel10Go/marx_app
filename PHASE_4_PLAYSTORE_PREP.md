# Phase 4: Play Store Preparation Checklist (10.05.2026)

**Status:** Vorbereitung für Google Play Console Upload  
**Priorität:** Alle Items MÜSSEN vor Internal Track Upload abgeschlossen sein  
**AAB Build Status:** In Progress... (started 10.05.2026 ~11:15 CEST)

---

## 📋 Pre-Upload Metadaten (Store Listing)

Alle Items aus `tools/playstore_metadata.md` sind vorbereitet. Folgende Punkte müssen im Play Console konfiguriert werden:

### ✅ Basis-Informationen
- [x] App Title: **Marx Zitatatlas**
- [x] Category: **Books & Reference**
- [x] Content Rating: **3+**
- [x] Support Email: support@yourdomain.tld (anpassen!)
- [x] Privacy Policy URL: https://yourdomain.tld/privacy (anpassen!)

### ✅ Beschreibungen (aus playstore_metadata.md)
- [x] Short Description: "Taegliche Karl-Marx-Zitate, Archivsuche, Favoriten und Premium-Funktionen."
- [x] Full Description (DE):
  ```
  Marx Zitatatlas bringt dir taeglich kuratierte Zitate von Karl Marx direkt auf dein Geraet.
  
  Das bietet die App:
  - Tageszitat mit schneller Uebersicht
  - Archiv mit Suche und Filtern
  - Favoriten zum Speichern deiner wichtigsten Zitate
  - Detailseiten mit Kontext und Einordnung
  - Stabile Offline-Fallbacks fuer zentrale Inhalte
  
  Premium-Funktionen:
  - Erweiterte Nutzungserlebnisse fuer intensive Arbeit mit Zitaten
  - Zusätzliche Komfortfunktionen und vertiefte Exploration
  
  Die App ist auf einen klaren Lesefluss, schnelle Navigation und robuste Performance ausgelegt.
  ```

### ✅ Release Notes (DE)
- [x] Initialversion: "Taegliche Marx-Zitate, Archivsuche, Favoriten, Premium-Funktionen und verbesserte Stabilitaet."

---

## 📸 Screenshots (PENDING - manuell erforderlich)

### Erforderliche Screenshots

Play Store verlangt Screenshots für mindestens 2 Display-Größen:

#### 6.7" Phone (1440x2560px) - 5 Screenshots
- [ ] **Screenshot 1:** Home Screen mit Tageszitat
- [ ] **Screenshot 2:** Quote Detail mit Erklärung
- [ ] **Screenshot 3:** Archive mit aktiver Suche/Filter
- [ ] **Screenshot 4:** Premium/Paywall mit Pricing
- [ ] **Screenshot 5:** Settings/Account Screen

#### 5.1" Phone (1080x1920px) - 5 Screenshots
- [ ] **Screenshot 1:** Home Screen mit Tageszitat
- [ ] **Screenshot 2:** Quote Detail mit Erklärung
- [ ] **Screenshot 3:** Archive mit aktiver Suche/Filter
- [ ] **Screenshot 4:** Premium/Paywall mit Pricing
- [ ] **Screenshot 5:** Settings/Account Screen

#### Feature Graphic (1024x500px) - Banner
- [ ] Feature Banner mit App-Icon + "Marx Zitatatlas" + kurzer Tagline

### Screenshot-Erfassung (Optionen)

**Option A: Emulator Screenshots (schnell, kostenlos)**
```bash
# Pixel 6 Emulator starten
flutter emulators --launch Pixel_6

# Mit Screenshots arbeiten
# Nutze Android Studio oder adb zum Erfassen
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png ./assets/screenshots/play/
```

**Option B: Device Screenshots (realistisch)**
- Echter Pixel 6 (falls vorhanden)
- App laden, Screenshots via ADB oder Gerät-Screenshots erstellen
- Pfad: `assets/screenshots/play/phone67_*.png`

**Option C: Pre-Rendered Screenshots (zeitoptimiert für MVP)**
- Vereinfachte Grafiken mit App-UI-Mockups
- Tool: Figma, Photoshop, oder online Screenshot-Tools
- Schneller, aber weniger authentisch

### Empfohlene Herangehensweise (diese Woche)
1. **Heute:** Emulator starten, 5-6 schnelle Screenshots pro Größe erfassen
2. **Morgen:** Play Console hochladen, Content Review durchführen
3. **Falls nötig:** Später mit echtem Device verfeinern

---

## 🎯 Google Play Developer Account Setup

### Account-Vorbereitung
- [ ] Google-Konto vorhanden (mit 2FA empfohlen)
- [ ] Zahlungsmethode hinterlegt (Kreditkarte, Lastschrift, etc.)
- [ ] Telefon zur Bestätigung verfügbar
- [ ] Developer Account-Gebühr: **$25** (einmalig, bezahlen Sie nach Anmeldung)

### Account-Erstellung (MACHEN Sie bei Play Console):
1. Gehen Sie zu: https://play.google.com/console
2. Klicken Sie auf **Create Account**
3. Füllen Sie Entwickler-Informationen aus:
   - Developer Name: z.B. "Marx App Dev" oder Ihr Name
   - Email: Developer-Email (wichtig für Kommunikation)
   - Zahlungsinformation: Kreditkarte oder Bankverbindung
4. Bestätigen Sie die Developer Agreement
5. Zahlen Sie die $25-Gebühr
6. Warten Sie auf Account-Bestätigung (meist wenige Minuten)

### Nach Account-Erstellung:
- [ ] Neues Projekt erstellen: "Marx Zitatatlas"
- [ ] App-Bundle hochladen (nach AAB-Completion)
- [ ] Metadaten eintragen (Title, Description, Category, etc.)
- [ ] Privacy Policy & Support Email setzen
- [ ] Content Rating Fragebogen ausfüllen (3-5 min)
- [ ] In-App Products konfigurieren (siehe unten)

---

## 💳 In-App Products (RevenueCat Integration)

Folgende Products MÜSSEN in Google Play Console erstellt werden:

### Monthly Subscription
- **Product ID:** `com.marxapp.zitate_app_pro_monthly_android`
- **Billing Period:** 1 Month
- **Price (EUR):** €3.99 (oder regional angepasst)
- **Free Trial:** 7 days (optional, empfohlen)
- **Entitlement:** `zitate_app_pro` (in RevenueCat konfigurieren)

### Yearly Subscription
- **Product ID:** `com.marxapp.zitate_app_pro_yearly_android`
- **Billing Period:** 1 Year
- **Price (EUR):** €29.99 (oder regional angepasst)
- **Free Trial:** 7 days (optional, empfohlen)
- **Entitlement:** `zitate_app_pro` (in RevenueCat konfigurieren)

### Konfigurationsschritte in Play Console:
1. Gehen Sie zu: **Monetize → In-app Products**
2. Klicken Sie auf **Create Product**
3. Füllen Sie folgende Felder:
   - Name: "Marx Pro Monthly" / "Marx Pro Yearly"
   - Product ID (exakt wie oben)
   - Subscription periode
   - Default price in EUR
4. Speichern Sie und wiederholen Sie für das zweite Produkt

### Konfigurationsschritte in RevenueCat:
1. Gehen Sie zu RevenueCat Dashboard
2. Gehen Sie zu **Offerings → Add or Edit Offerings**
3. Erstellen Sie ein Offering namens `default`:
   - Package `monthly` → Map zu Google Play Product `com.marxapp.zitate_app_pro_monthly_android`
   - Package `yearly` → Map zu Google Play Product `com.marxapp.zitate_app_pro_yearly_android`
   - Entitlement: `zitate_app_pro`
4. Speichern und testen

---

## 🔍 Content Rating Fragebogen (Google Play)

Der Content Rating Fragebogen ist ERFORDERLICH vor Public Launch.

### Fragebogen-Items (typischerweise 3-5 Minuten):
- Violence: **No** (nur Text-Zitate, keine Gewalt)
- Sexual Content: **No**
- Alcohol/Tobacco: **No**
- Drugs: **No**
- Gambling: **No**
- Language/Profanity: **Mild** (Marx-Zitate sind philosophisch, keine vulgären Inhalte)
- Other: No

### Nach Ausfüllung:
- Play Console zeigt **Suggested Rating: 3+** (PEGI) oder **E** (ESRB)
- Bestätigen Sie diese Rating und speichern Sie

---

## 📱 Privacy Policy & Settings

### Privacy Policy
- [x] URL MUSS in Play Console gesetzt werden
- [ ] Policy-URL: https://yourdomain.tld/privacy (Sie müssen diese selbst hosten)
- [ ] Policy-Inhalt sollte abdecken:
  - Welche Daten Sie sammeln (User Favorites, Settings, Email falls Auth)
  - Wie Sie Daten speichern (Supabase + lokale SQLite)
  - Zugriff durch Dritte (RevenueCat, Supabase, Google Play)
  - DSGVO-Rechte (Export, Delete — bereits implementiert! ✅)

### Support Email
- [ ] Email setzen: z.B. support@yourdomain.tld
- [ ] Diese Email muss monitored werden für Nutzer-Fragen

---

## 🚀 Pre-Launch Checklist

Folgende Punkte müssen VOR dem Play Console Upload gepflegt sein:

### Play Console Metadaten
- [ ] App Title: Marx Zitatatlas
- [ ] Category: Books & Reference
- [ ] Content Rating: 3+
- [ ] Short Description: ✅ (ready)
- [ ] Full Description (DE): ✅ (ready)
- [ ] Screenshots (2 sizes, 5 pro size): ⏳ IN PROGRESS
- [ ] Feature Graphic: ⏳ IN PROGRESS
- [ ] App Icon (512x512): ✅ (exists at assets/branding/app_icon.png)
- [ ] Privacy Policy URL: ⏳ NEEDED
- [ ] Support Email: ⏳ NEEDED
- [ ] Content Rating Form: ⏳ IN PROGRESS

### RevenueCat Configuration
- [x] Test API Key: test_PekobyLoTBNwtOUgnVmtfRCAclN (active)
- [ ] Prod API Key: ⏳ NEEDED (nach Account Setup)
- [ ] Offerings configured: ⏳ PENDING (nach Play Console Products)
- [ ] Entitlements: zitate_app_pro ✅ (exists)

### Android Build
- [ ] `flutter build appbundle --release` → Success ⏳ IN PROGRESS (~10 min)
- [ ] AAB Datei: `build/app/outputs/bundle/release/app-release.aab` ⏳ PENDING

### Internal Test Track
- [ ] Play Console Internal Testing aktiviert
- [ ] AAB hochgeladen
- [ ] Test Link mit Testern geteilt
- [ ] Pixel6 QA durchgeführt (LOGIN, PURCHASE, RESTORE, SYNC)
- [ ] Ergebnisse in TEST_RUNBOOK dokumentiert

---

## 📅 Empfohlener Timeline

### Heute (10.05.2026)
1. ✅ AAB Build zu Ende bringen (läuft gerade)
2. ⏳ Screenshots erfassen (Emulator oder Device) — ca. 30-45 min
3. ⏳ Play Console Account erstellen ($25 Gebühr) — ca. 10-15 min
4. ⏳ App-Eintrag + Metadaten eingeben — ca. 30-45 min
5. ⏳ In-App Products konfigurieren — ca. 15-20 min

### Morgen (11.05.2026)
1. Verfeinern von Metadaten auf Basis von Play Console Validation
2. Content Rating Fragebogen ausfüllen
3. AAB in Internal Track hochladen
4. Test Link an QA Testers verteilen
5. Final Pixel6 QA starten

### Nach QA (12.05.2026)
1. Closed Beta Testing (optional, 1-2 Tage)
2. Production Release (starten bei 10-25% Rollout, beobachten 24-48h)
3. Graduelle Rollout-Erhöhung auf 100%

---

## 🆘 Häufige Fehler (Vermeidung)

1. **Fehlende Privacy Policy URL**
   - Fehler: "Privacy Policy is required"
   - Lösung: MUSS vor Upload gesetzt werden

2. **Falsche In-App Product IDs**
   - Fehler: RevenueCat kann Products nicht mappen
   - Lösung: IDs EXAKT wie in Play Console gespeichert verwenden

3. **AAB nicht signiert**
   - Fehler: Play Console lehnt Upload ab
   - Lösung: release.keystore + key.properties prüfen ✅ (bereits done)

4. **Screenshots zu klein / zu groß**
   - Fehler: Play Console lehnt ab
   - Lösung: Exakte Pixel (1440x2560 oder 1080x1920) verwenden

5. **Content Rating nicht ausgefüllt**
   - Fehler: App kann nicht in Produktion gehen
   - Lösung: Fragebogen MUSS vor Public Release ausgefüllt sein

---

## 📞 Support & Next Steps

- **Blockiert?** Prüfen Sie die Runbooks:
  - [PHASE_4_DEPLOYMENT_GUIDE.md](PHASE_4_DEPLOYMENT_GUIDE.md)
  - [INTERNAL_TRACK_UPLOAD_RUNBOOK.md](INTERNAL_TRACK_UPLOAD_RUNBOOK.md)
  - [TEST_RUNBOOK_PIXEL6_FINAL_QA.md](TEST_RUNBOOK_PIXEL6_FINAL_QA.md)

- **Screenshots-Hilfe:** Siehe Screenshot-Erfassung oben, oder nutzen Sie einen Screenshot-Service

- **Play Console Probleme?** Google Play Console Support: https://support.google.com/googleplay/

---

**Nächster Schritt:** AAB Build abwarten → Screenshots erfassen → Play Console Account erstellen
