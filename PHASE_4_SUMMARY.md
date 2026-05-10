# Phase 4 Quick Summary & Next Steps (10.05.2026)

**Ziel dieser Session:** Phase 3.5 abschließen ✅ + Phase 4 Launch-Vorbereitung starten  
**Status:** 90% vorbereitet, AAB Build läuft noch

---

## ✅ Diese Session Erledigte Tasks

### Phase 3.5 Completion
- [x] Account Privacy Service (Export/Delete) vollständig implementiert
- [x] DSGVO Export: JSON mit Nutzerdaten, Settings, Favoriten
- [x] DSGVO Delete: Lokale + Cloud Daten gelöscht mit Confirmation Dialog
- [x] Android Release Signing: Keystore verifiziert, key.properties konfiguriert
- [x] Code linting & analyze: Alle Warnings gelöst
- [x] LAUNCH_CHECKLIST.md aktualisiert mit abgehakten Punkten

### Phase 4 Vorbereitung
- [x] Play Store Metadaten dokumentiert (playstore_metadata.md)
- [x] Phase 4 Playstore Prep Checklist erstellt (PHASE_4_PLAYSTORE_PREP.md)
- [x] Screenshots Capture Guide erstellt (SCREENSHOTS_CAPTURE_GUIDE.md)
- [ ] Android AAB Release Build: IN PROGRESS (Gradle task bundleRelease läuft)
- [ ] Screenshots erfassen (next: Emulator oder Device capture)
- [ ] Google Play Developer Account erstellen ($25 fee)

---

## 🚀 Nächste 5 Schritte (Diese Woche)

### **HEUTE (10.05.2026):**

1. **✓ Phase 3.5 abhacken** — DONE ✅
   - Alle Code-Änderungen sind implementiert und geprüft
   - LAUNCH_CHECKLIST aktualisiert

2. **⏳ AAB Build zu Ende bringen** — IN PROGRESS
   - Kommando: `flutter clean && flutter build appbundle --release`
   - Output: `build/app/outputs/bundle/release/app-release.aab`
   - ETA: +2-3 Minuten von jetzt an

3. **⏳ Screenshots erfassen** (30-45 Min parallel zum Build)
   - Nutze Emulator oder echtes Device
   - 5 Screenshots für 6.7" (1440x2560px)
   - 5 Screenshots für 5.1" (1080x1920px)
   - 1 Feature Graphic (1024x500px)
   - Guide: SCREENSHOTS_CAPTURE_GUIDE.md

4. ⏳ **Play Console Account Setup** (10-15 Min)
   - Gehe zu https://play.google.com/console
   - Developer Account erstellen ($25 Gebühr)
   - App-Eintrag "Marx Zitatatlas" anlegen

5. **⏳ Play Store Metadaten eintragen** (30-45 Min)
   - Descriptions: Short & Full (Deutsche Versionen ready)
   - Screenshots hochladen (5+5+1 Bilder)
   - Category, Content Rating, Privacy Policy URL
   - Support Email
   - Referenz: PHASE_4_PLAYSTORE_PREP.md

### **MORGEN (11.05.2026):**

1. **In-App Products konfigurieren** (15-20 Min)
   - Monthly: `com.marxapp.zitate_app_pro_monthly_android` (€3.99)
   - Yearly: `com.marxapp.zitate_app_pro_yearly_android` (€29.99)

2. **Content Rating Fragebogen** (5-10 Min)
   - Google Play Content Rating Form ausfüllen
   - Typ: "Books & Reference" → Meist Rating "3+" oder "E" (ESRB)

3. **Internal Testing Track Setup** (15 Min)
   - AAB hochladen zu "Internal Testing"
   - Internal Test Link generieren
   - Tester hinzufügen (Google-Konten)

4. **Pixel6 Final QA durchführen** (30-60 Min)
   - Install via Internal Test Link
   - Test: Cold Start, Offline, Navigation, Purchase, Restore, Login, Sync
   - Ergebnisse dokumentieren in TEST_RUNBOOK_PIXEL6_FINAL_QA.md

### **NACH QA (12.05.2026):**

1. **Closed Beta (optional, 1-2 Tage)**
   - 5-10 externe Tester einladen
   - Feedback sammeln

2. **Production Release mit Rollout**
   - Starte 10-25% Rollout
   - Monitor 24-48h auf Crashes & Ratings
   - Graduelle Erhöhung auf 100%

---

## 📊 Blockade-Status

### 🟢 Gelöst/Bereit
- [x] Account Privacy (DSGVO) — Code DONE
- [x] Android Signing — Keystore verified
- [x] Play Store Metadaten — Templates ready
- [x] Code Quality — All lint/analyze PASS

### 🟡 In Progress
- ⏳ AAB Build — Gradle task active (~2-3 min)
- ⏳ Screenshots — Capture guide ready, just need to execute

### 🔴 Noch zu tun (aber nicht blockierend)
- Google Play Dev Account ($25) — 10 Min online
- Play Console Setup — 1-2 Stunden total
- Internal QA — 30-60 Min auf Gerät

---

## 💡 Tipps & Best Practices

1. **AAB Build Timeout?**
   - Gradle auf Windows kann langsam sein (10+ Min ist normal)
   - Lasse den Terminal laufen, gehe nicht weg

2. **Screenshots Tipps**
   - Nutze Emulator für schnelle Captures (kostenlos)
   - Stelle sicher, dass App in "purem" Zustand ist vor jedem Screenshot
   - Keine Test-Daten in Screenshots (z.B. "admin" als Account-Name)

3. **Play Store Metadaten**
   - Beschreibungen sind fertig in playstore_metadata.md
   - Copy-paste in Play Console
   - Keine Spezial-Zeichen außer Standard-Deutsch (ä, ö, ü ok)

4. **RevenueCat Kopplung**
   - Nach Product-Creation in Play Console → RevenueCat Dashboard
   - Map Product-IDs 1-zu-1
   - Test mit Test-Account BEVOR Produktion

5. **Pixel6-QA zeitsparen**
   - Nutze Checklist aus TEST_RUNBOOK_PIXEL6_FINAL_QA.md
   - Fokus auf: Install, Cold Start, Purchase, Restore, Login
   - Andere Flows (Offline, Back Button) sind bereits getestet

---

## 📞 Wichtige Links & Dokumente

- **Phase 4 Playstore Prep:** [PHASE_4_PLAYSTORE_PREP.md](PHASE_4_PLAYSTORE_PREP.md)
- **Screenshots Guide:** [SCREENSHOTS_CAPTURE_GUIDE.md](SCREENSHOTS_CAPTURE_GUIDE.md)
- **Playstore Metadata:** [tools/playstore_metadata.md](tools/playstore_metadata.md)
- **Internal Track Runbook:** [INTERNAL_TRACK_UPLOAD_RUNBOOK.md](INTERNAL_TRACK_UPLOAD_RUNBOOK.md)
- **Pixel6 QA Runbook:** [TEST_RUNBOOK_PIXEL6_FINAL_QA.md](TEST_RUNBOOK_PIXEL6_FINAL_QA.md)
- **Play Console:** https://play.google.com/console
- **RevenueCat Dashboard:** https://dashboard.revenuecat.com

---

## ⏱️ Zeitschätzung (Total für Phase 4)

| Aufgabe | Zeit | Tag |
|---|---|---|
| AAB Build | 5-10 Min | Heute |
| Screenshots erfassen | 30-45 Min | Heute (parallel) |
| Play Console Account | 10-15 Min | Heute oder Morgen |
| Metadaten eintragen | 30-45 Min | Morgen |
| In-App Products | 15-20 Min | Morgen |
| Content Rating Form | 5-10 Min | Morgen |
| Internal Track Upload | 10-15 Min | Morgen |
| Pixel6 Final QA | 30-60 Min | Morgen |
| **TOTAL** | **2-3 Stunden** | **Heute + Morgen** |

---

## ✅ Handoff Checklist

Bevor wir diese Session abschließen, sollten folgende Dinge vorhanden sein:

- [x] LAUNCH_CHECKLIST.md aktualisiert mit Phase 3.5 ✅ & Phase 4 starting
- [x] Phase 3.5 Code-Implementierung abgeschlossen & getestet
- [x] PHASE_4_PLAYSTORE_PREP.md erstellt (vollständige Checkliste)
- [x] SCREENSHOTS_CAPTURE_GUIDE.md erstellt (Step-by-Step)
- [x] AAB Build startet (Gradle task active)
- [ ] AAB Build erfolgreich & verifiziert (pending ~2-3 Min)
- [ ] Screenshots erfasst (pending, guide ready)
- [ ] Play Console Account erstellt (pending, guide ready)

**Minimum für erfolgreiche Phase 4 Vorbereitung:**
1. ✅ All documentation ready
2. ✅ Code is production-ready
3. ⏳ AAB Build fertig (läuft)
4. ⏳ Screenshots guide (ready to execute tomorrow)

---

**Status:** Auf Schiene für Launch Ende Mai 2026. Alle kritischen Code-Arbeiten erledigt. Phase 4 ist reine Verwaltungs- & Test-Arbeit (keine Coding mehr erforderlich bis QA).
