# Play Store Screenshots Capture Guide (Phase 4)

**Datum:** 10.05.2026  
**Ziel:** Screenshots für Google Play Console (2 Display-Größen, 5 Bilder pro Größe)  
**Status:** Vorbereitung für Internal Track Upload

---

## Übersicht

Google Play Console verlangt Screenshots für mindestens **2 Display-Größen**:

| Display-Größe | Resolution | Screenshots | Gesamtanzahl |
|---|---|---|---|
| **6.7" Phone** | 1440x2560px | 5 Bilder | 5 |
| **5.1" Phone** | 1080x1920px | 5 Bilder | 5 |
| **Feature Graphic** | 1024x500px | 1 Banner | 1 |
| **TOTAL** | — | — | **11 Bilder** |

---

## Methode A: Emulator Screenshots (Schnell & Kostenlos) ⭐ EMPFOHLEN

### Schritt 1: Flutter Emulator Starten

```bash
# Verfügbare Emulatoren prüfen
flutter emulators

# Wähle Pixel 6 Emulator aus und starten
flutter emulators --launch Pixel_6

# Oder über Android Studio starten:
# - Android Studio → AVD Manager
# - Wähle "Pixel 6" → Grünes Play-Icon klicken
```

### Schritt 2: App auf Emulator laden

```bash
# Im marx_app Verzeichnis:
flutter run -d emulator-5554

# Die App sollte nach ~20-30 Sekunden starten
```

### Schritt 3: Screenshots erfassen

#### Option A: Emulator Built-in Screenshot (einfach)
```bash
# Emulator läuft → Rechts-Menü öffnen → Screenshot-Icon klicken
# Datei wird heruntergeladen
```

#### Option B: ADB Screenshots (zuverlässig)
```powershell
# PowerShell / CMD im marx_app Verzeichnis

# Screenshot vom Emulator machen
adb shell screencap -p /sdcard/screenshot.png

# Datei auf den PC herunterladen
adb pull /sdcard/screenshot.png ./playstore_screenshot_1.png

# Oder mehrere Screenshots nacheinander (mit numerischen Suffixen)
adb shell screencap -p /sdcard/screenshot_2.png
adb pull /sdcard/screenshot_2.png ./playstore_screenshot_2.png
```

### Schritt 4: Screenshots lokal speichern

```
assets/screenshots/play/
├── phone67_01_home.png (1440x2560px)
├── phone67_02_detail.png (1440x2560px)
├── phone67_03_archive.png (1440x2560px)
├── phone67_04_paywall.png (1440x2560px)
├── phone67_05_settings.png (1440x2560px)
├── phone51_01_home.png (1080x1920px)
├── phone51_02_detail.png (1080x1920px)
├── phone51_03_archive.png (1080x1920px)
├── phone51_04_paywall.png (1080x1920px)
├── phone51_05_settings.png (1080x1920px)
└── feature_graphic_1024x500.png (Banner)
```

### Schritt 5: Vor jedem Screenshot präparieren

**Vor Screenshot 1 (Home):**
- App ist frisch gestartet
- Tageszitat angezeigt
- Gutes Licht/Kontrast auf Home Screen

**Vor Screenshot 2 (Detail):**
- Klicke auf das Tageszitat
- Quote Detail öffnet sich
- Erklärung ist sichtbar

**Vor Screenshot 3 (Archive):**
- Gehe zu Archive Tab
- Nutze ein paar Filter/Suchbegriffe
- Zeige "Suchergebnisse vorhanden"

**Vor Screenshot 4 (Paywall):**
- Versuche eine Pro-Funktion zu nutzen
- Paywall öffnet sich mit Pricing
- Monthly + Yearly Optionen sichtbar

**Vor Screenshot 5 (Settings):**
- Gehe zu Settings Tab
- Zeige Account/User-Info
- Oder Favoriten wenn angemeldet

---

## Methode B: Real Device Screenshots (Authentisch aber aufwändiger)

Falls Sie einen Pixel 6 oder ähnliches Android-Gerät haben:

### Schritt 1: Device mit PC verbinden

```bash
# USB-Kabel anschließen
# Gerät-Dialog: "USB Debugging erlauben?" → JA

# Gerät prüfen:
adb devices
# Output sollte zeigen: device-serial    device
```

### Schritt 2: App auf Gerät installieren

```bash
# Baue APK/AAB für Debug
flutter install

# Oder über Play Console Internal Track (nach Upload)
# → Internal test link → App installieren
```

### Schritt 3: Screenshots erfassen (ADB oder Gerät-Button)

```bash
# Via ADB (wie oben)
adb shell screencap -p /sdcard/Pictures/screenshot.png
adb pull /sdcard/Pictures/screenshot.png ./phone_screenshot.png

# Oder via Gerät:
# Power + Volume Down = Screenshot (meist 2 Sekunden halten)
# Screenshots speichern in Galerie
# Manuell auf PC übertragen
```

---

## Methode C: Screenshot-Tool / Service (Online)

Für schnelle Ergebnisse (aber weniger authentisch):

- **BrowserStack**: https://www.browserstack.com/screenshots
- **Responsive Design Checker**: Zeigt verschiedene Resolutionen
- **Figma Screenshots**: Mock-Ups mit UI-Elementen

Nachteil: Nicht mit echtem App-Content, aber brauchbar für MVP-Phase.

---

## Feature Graphic (1024x500px Banner)

Der Feature Graphic wird oben in der Play Store Listing angezeigt.

### Option A: Schnell mit Tools
```
- Figma Template: https://www.figma.com/templates/playstore-banner/
- Canva Template: https://www.canva.com/search/google%20play%20store%20banner/
- Persönlich: Nutze App-Icon + "Marx Zitatatlas" Text + Tagline
```

### Option B: Screenshot + Text Overlay (PowerPoint/GIMP)
1. Nimm einen Home-Screen Screenshot (1440x2560)
2. Zuschneiden auf 1024x500px (top/center)
3. Text hinzufügen: "Marx Zitatatlas" (groß)
4. Speichere als PNG

### Option C: Professionelles Design (Zeit aufwändig)
- Nutze Canva oder Adobe Express
- Zielpixel: 1024x500
- Farben: Konsistent mit App-Theme
- Text: Klare, lesbare Font (z.B. sans-serif)
- Icon: App-Icon in Ecke platzieren

---

## Bearbeitungs-Tipps (Falls Screenshots zu dunkel/unlesbar sind)

### Mit Emulator-Tools
1. Emulator → Settings → Display Brightness anpassen
2. App-Theme sicherstellen (hellster Kontrast)
3. Text und UI-Elemente sollten deutlich lesbar sein

### Mit PC-Tools (nach Screenshot)
- **Windows Photos**: Basic Helligkeit/Kontrast anpassen
- **GIMP** (kostenlos): https://www.gimp.org/
  - Öffne Screenshot
  - Colors → Brightness-Contrast (leicht erhöhen)
  - Speichere als PNG

---

## Play Console Upload-Format

Wenn Screenshots fertig sind:

1. Gehe zu Play Console → Deine App → Store Listing
2. Klicke auf "Screenshots" (Phone-Section)
3. Lade hochgeladene Bilder hoch:
   - "Add image" → Wähle 6.7"-Screenshots (5 Bilder)
   - Bestätigung → speichern
   - Wiederhole für 5.1"-Screenshots
4. Unter "Feature graphic" Upload des 1024x500-Banners
5. "Save" und überprüfen

### Akzeptierte Formate:
- PNG, JPG, GIF
- Größe: Mindestens exakte Resolution (1440x2560 oder 1080x1920)
- Max. Dateigröße: 10MB pro Bild

---

## Zeitschätzung

| Methode | Zeit | Qualität |
|---|---|---|
| **A: Emulator** | 30-45 Min | 🟢 Gut (authentisch) |
| **B: Real Device** | 45-60 Min | 🟢🟢 Sehr gut (echt) |
| **C: Online Tool** | 15-20 Min | 🟡 Akzeptabel (einfach) |
| **Feature Graphic** | 10-15 Min | 🟢 Gut (mit Figma/Canva) |

### Empfehlung für MVP (diese Woche)
- **Emulator Screenshots**: 30-45 Min ✅ (kostet nichts, schnell)
- **Feature Graphic**: 10-15 Min ✅ (Canva kostenlos)
- **TOTAL**: ~45-60 Min für alle 11 Bilder

---

## Quality Checklist für Screenshots

- [ ] Bild ist scharf und lesbar
- [ ] Text ist deutlich erkennbar (> 10pt empfohlen)
- [ ] App-UI nimmt ~90% des Bildes ein
- [ ] Keine Android-Navigation-Bar oben/unten (meist verborgen)
- [ ] Farben sind konsistent mit App-Theme
- [ ] Keine Personen-Daten oder Test-Daten sichtbar
- [ ] Alle 5 Screenshots zeigen verschiedene Bildschirme (keine Duplikate)

---

## Nächste Schritte nach Screenshot-Erfassung

1. ✅ Screenshots erfassen & speichern (diesen Tag, ~45-60 Min)
2. ⏳ Play Console Account erstellen ($25) — nächster Tag
3. ⏳ App-Eintrag erstellen & Metadaten eingeben
4. ⏳ Screenshots hochladen
5. ⏳ In-App Products konfigurieren (Monthly/Yearly)
6. ⏳ Content Rating Fragebogen ausfüllen
7. ⏳ AAB in Internal Track hochladen
8. ⏳ Pixel6-QA durchführen

---

## Troubleshooting

### "flutter emulators --launch Pixel_6" funktioniert nicht
→ Android Studio öffnen → AVD Manager → Neuen Emulator anlegen

### ADB erkennt Emulator nicht
```bash
# ADB neu starten
adb kill-server
adb start-server
adb devices
```

### Screenshots kommen zu dunkel an
→ In Emulator: Settings → Display → Brightness erhöhen
→ Oder nachträglich mit GIMP anpassen

### Dateigröße zu groß für Play Console
→ PNG komprimieren: https://tinypng.com/ oder ImageMagick

---

**Hinweis:** Wenn Sie Zeit sparen möchten, können Sie auch ein Bild als "placeholder" verwenden und später verfeinern. Play Console akzeptiert Screenshots auch nach dem Upload (vor Submission zur Review).
