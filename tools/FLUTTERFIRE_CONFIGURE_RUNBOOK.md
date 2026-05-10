# FlutterFire Configure Runbook

Zweck: Firebase für Android/iOS konfigurieren, `firebase_options.dart` generieren und Crashlytics aktivieren.

Voraussetzungen:
- Firebase-Projekt angelegt (Project ID verfügbar).
- `dart`/`flutter` in PATH; `flutter pub get` funktioniert.
- `flutterfire_cli` installiert (siehe unten).
- Android `applicationId` ist `com.example.marx_app` (aus `android/app/build.gradle.kts`).
- iOS Bundle ID: ersetze `<IOS_BUNDLE_ID>` mit deinem Xcode `PRODUCT_BUNDLE_IDENTIFIER`.

Sichere Orte und Dateien:
- `lib/firebase_options.dart` wird vom `flutterfire configure` erzeugt.
- `android/app/google-services.json` und `ios/Runner/GoogleService-Info.plist` müssen in die jeweiligen Plattform-Ordner gelegt werden.

1) FlutterFire CLI installieren (falls noch nicht):
```bash
dart pub global activate flutterfire_cli
```

2) (Optional) Anmelden bei Firebase in CLI (öffnet Browser):
```bash
flutterfire login
```

3) `flutterfire configure` ausführen (ersetze `PROJECT_ID` und ggf. den iOS-Bundle-ID):
```bash
flutterfire configure \
  --project PROJECT_ID \
  --out=lib/firebase_options.dart \
  --android-package com.example.marx_app \
  --ios-bundle-id <IOS_BUNDLE_ID> \
  --platforms android,ios
```

Hinweis: Wenn die CLI nach App-IDs fragt, wähle die vorhandenen Android/iOS Apps in deinem Firebase-Projekt oder erstelle sie temporär in der Console, damit `google-services.json` / `GoogleService-Info.plist` verknüpft werden.

4) Dateien prüfen und an die richtigen Orte kopieren (falls `flutterfire` sie nicht automatisch platziert):
- `google-services.json` → `android/app/google-services.json`
- `GoogleService-Info.plist` → `ios/Runner/GoogleService-Info.plist`

5) Abhängigkeiten holen und App lokal bauen:
```bash
flutter pub get
flutter build apk --release
```

6) Crashlytics aktivieren in Firebase Console:
- In der Firebase Console: Crashlytics → App auswählen → Crashlytics aktivieren und bei Bedarf das SDK initialisieren (wir haben `firebase_crashlytics` bereits als Dependency hinzugefügt).

7) Native ProGuard / mapping Upload (Android):
- Nach `flutter build appbundle --release` liegt die Mapping-Datei unter `build/app/outputs/mapping/release/mapping.txt`.
- Lade diese Datei in der Firebase Console für Crashlytics oder konfiguriere Play Console automatic upload (empfohlen).

8) iOS dSYM Upload (iOS):
- Verwende `firebase crashlytics:upload-dsym` oder binde Upload in CI. Siehe Firebase Dokumentation für `upload-symbols`.

9) Verifizieren:
- Starte die App lokal (Release-Mode auf Testgerät) und löse testweise einen Crash über `FirebaseCrashlytics.instance.crash();` (nur kurz zum Testen) oder sende ein Test-NonFatal-Report.
- Prüfe Firebase Console Crashlytics, ob Reports ankommen.

Tipps / Troubleshooting:
- Wenn `flutterfire configure` scheitert wegen Berechtigungen, stelle sicher, dass du mit dem Google-Account angemeldet bist, der Zugriff auf das Firebase-Projekt hat.
- Wenn `firebase_options.dart` Fehlermeldungen erzeugt, prüfe `package:firebase_core` und `firebase_crashlytics` Versionen in `pubspec.yaml`.

Weiteres: Nachdem `lib/firebase_options.dart` erzeugt ist, läuft Crashlytics-Initialisierung über `lib/core/services/crash_reporting_service.dart` (bereits im Repo). Folge den Schritten oben, teste lokal, und dann lade die AAB in Play Internal Track.

— Ende —
