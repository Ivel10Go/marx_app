**Übersicht**
- **Zweck:** Schritt-für-Schritt-Anleitung zur Integration von RevenueCat (Flutter) inkl. Beispielcode, Fehlerbehandlung und Best Practices.
- **Voraussetzung:** RevenueCat Account, Play Console Zugang, Flutter-Umgebung.

---

## 1) Pakete installieren

Im Projektverzeichnis ausführen:

```bash
flutter pub add purchases_flutter purchases_ui_flutter
flutter pub get
```

Hinweis: Ich habe Beispiel-Dateien im Repo angelegt: Initialisierung in [lib/main.dart](lib/main.dart#L1) und ein Beispiel-Paywall unter [lib/paywall.dart](lib/paywall.dart#L1).

## 2) Native Voraussetzungen

- Android: Lege die Produkte in der Play Console an (siehe Abschnitt "Produkte"). `applicationId` (android/app/build.gradle.kts) muss mit Play Package übereinstimmen.
- iOS: Aktiviere In-App-Purchases in Xcode, konfiguriere Produkte in App Store Connect.

## 3) Produkte (Empfohlene IDs)

- monthly: `com.example.marx_app.zitate_app_pro_monthly_android`
- yearly: `com.example.marx_app.zitate_app_pro_yearly_android`
- lifetime: `com.example.marx_app.zitate_app_pro_lifetime_android` (one-time)

Erstelle dieselben Store-Produkt-IDs in RevenueCat (Apps → Products).

## 4) RevenueCat Dashboard: Entitlement & Offering

1. Entitlements → neues Entitlement `zitate_app_pro` anlegen.
2. Offerings → `default` erstellen, Packages für monthly/yearly/lifetime zuordnen.
3. Sicherstellen, dass die Store-IDs korrekt den RevenueCat-Produkten zugeordnet sind.

## 5) SDK initialisieren (Runtime / Best Practice)

- Empfohlen: RevenueCat-Key via `--dart-define` übergeben, nicht im Code hardcoden.

Beispiel (Start / Dev):

```bash
flutter run --dart-define=REVENUECAT_API_KEY=test_PjGielVRVSTMPwgxgCkbstAiMjR
```

Initialisierung (Beispiel in `main()`):

```dart
import 'package:purchases_flutter/purchases_flutter.dart';

final rcKey = const String.fromEnvironment(
  'REVENUECAT_API_KEY',
  defaultValue: 'test_PjGielVRVSTMPwgxgCkbstAiMjR',
);

await Purchases.setDebugLogsEnabled(true);
await Purchases.configure(PurchasesConfiguration(rcKey));
```

> Hinweis: Ich habe die Initialisierung bereits in [lib/main.dart](lib/main.dart#L1) platziert. Wenn du einen zentralen `PurchasesService` bevorzugst, kann ich das auch patchen.

## 6) Paywall & Kauf-Flow (Flutter)

- Pattern: `getOfferings()` → Anzeigen von `Offering.current.availablePackages` → Kauf des ausgewählten `Package`.
- RevenueCat verarbeitet Transaktionen automatisch: iOS wird abgeschlossen, Android wird bestätigt/abgewickelt.
- Beispiel-Implementierung (bereits hinzugefügt): [lib/paywall.dart](lib/paywall.dart#L1). Sie zeigt:
  - Offerings laden
  - Kauf starten über das aktuelle SDK-Pattern
  - Wiederherstellen (`restorePurchases()`)
  - CustomerInfo-Listener

### Making Purchases

Der Kauf-Flow in RevenueCat sollte immer mit einem `Package` aus dem geladenen Offering starten. Das SDK übernimmt den eigentlichen Store-Checkout.

Beispiel:

```dart
final offerings = await Purchases.getOfferings();
final package = offerings.current?.availablePackages.first;

if (package != null) {
  final result = await Purchases.purchase(PurchaseParams.package(package));
  final customerInfo = result.customerInfo;

  if (customerInfo.entitlements.all['zitate_app_pro']?.isActive == true) {
    // Pro freischalten
  }
}
```

Fehlerbehandlung:

- Bei Kaufabbruch prüfe `PurchasesErrorCode.purchaseCancelledError`.
- Behandle Netzwerkfehler separat, damit du sinnvolle Nutzerhinweise anzeigen kannst.
- Wenn ein Kauf erfolgreich zurückkommt, ist `customerInfo` bereits aktualisiert und kann sofort zur Freischaltung genutzt werden.

Wichtig: prüfe das Entitlement mit:

```dart
final isPro = customerInfo.entitlements.all['zitate_app_pro']?.isActive ?? false;
```

## 7) CustomerInfo, Login, Restore

- Lese aktuelle Info: `await Purchases.getCustomerInfo()`.
- Login (wenn du eigene User-IDs nutzt): `await Purchases.logIn(userId)` → aktualisierte `CustomerInfo` zurück.
- Logout: `await Purchases.logOut()`.
- Wiederherstellen: `await Purchases.restorePurchases()`.

Fehlerbehandlung bei Kauf:

- Fange `PlatformException` und benutze `PurchasesErrorHelper.getErrorCode(e)` um `purchaseCancelledError` zu erkennen.
- Zeige dem Nutzer klare Fehler-Snackbar/Nachricht an und logge intern Debug-Informationen.

## 8) Paywall-Optionen: Hosted vs Custom

- Hosted Paywalls (RevenueCat Tools → Paywalls) sind schnell, können per Webview eingebunden oder per URL geöffnet werden.
- Custom Paywall (Flutter UI) bietet maximale Kontrolle — siehe [lib/paywall.dart](lib/paywall.dart#L1).

## 9) Customer Center

- Aktiviere in RevenueCat → Tools → Customer Center.
- Erzeuge (serverseitig empfohlen) einen Customer-Center-Link für den User und öffne ihn via `url_launcher`.

Einfaches Beispiel:

```dart
final url = 'https://app.revenuecat.com/customer-center?app=<your_app_id>&user_id=<your_user_id>';
await launchUrl(Uri.parse(url));
```

## 10) Tests & Debug

- Verwende Play Internal Test Track / TestFlight Sandbox.
- Aktiviere Debug-Logs: `Purchases.setDebugLogsEnabled(true)`.
- Prüfe Offerings-Fehler (Fehler in RevenueCat-Mapping, falsche Produkt-IDs sind häufige Ursachen).

### Vor dem Livegang (wenn die App noch nicht im Play Store live ist)

Das kannst du schon jetzt vollständig vorbereiten:

1. Play Console: Internal Test Track oder Closed Testing einrichten.
2. License Tester in Google Play anlegen und mit einem echten Google-Konto testen.
3. Produkte in Play Console anlegen und auf aktive Status prüfen.
4. Die gleichen Produkt-IDs in RevenueCat anlegen und auf das Entitlement `zitate_app_pro` mappen.
5. In RevenueCat ein Default Offering konfigurieren, damit `current` nicht leer ist.
6. App mit `--dart-define=REVENUECAT_API_KEY=test_...` starten und Paywall lokal testen.
7. Kauf, Restore, Entitlement-Check und Customer Center durchklicken.
8. Debug-Logs prüfen, falls Offerings leer sind oder Käufe nicht erscheinen.
9. Erst nach erfolgreichem Test-Track-Flow den Production-Key und einen echten Release-Track verwenden.

Praktische Testbefehle:

```bash
flutter run --dart-define=REVENUECAT_API_KEY=test_PjGielVRVSTMPwgxgCkbstAiMjR
flutter analyze lib/presentation/paywall/purchase_page.dart
```

Wichtig:
- Wenn die App noch nicht live ist, funktionieren Käufe nur zuverlässig über Test-/Internal-Tracks mit Testern.
- RevenueCat kann die Produkte erst sinnvoll ausspielen, wenn Store-Produkte und Offering korrekt gemappt sind.
- Der Paywall-Code ist schon vorbereitet, aber ohne Store- und RevenueCat-Konfiguration gibt es keine kaufbaren Pakete.

## 11) Webhooks & Server-Side

- Richte Webhooks in RevenueCat ein (für serverseitige Synchronisation von Käufen).
- Optional: Validiere Entitlements serverseitig via RevenueCat Server API für kritische Freischaltungen.

## 12) Best Practices (Kurz)

- Nutze `logIn(userId)` für stabile Zuordnung bei eigenem Auth-System.
- Reagiere auf `CustomerInfo`-Updates (SDK-Push), nicht nur auf Kauf-Result.
- Teste Wiederherstellung und Offline-Szenarien.
- Verwalte Keys via CI/Secrets, nicht im Quellcode.

---

Wenn du willst, patch ich jetzt noch:

- `PurchasesService` zum zentralen Initializer (liest `REVENUECAT_API_KEY` automatisch).
- UI-Integration: ein Settings-Item „Upgrade / Manage Subscription“ das `PaywallScreen` öffnet.

Gib kurz Bescheid, welche der beiden ich dir automatisch anlegen soll — dann mache ich die Änderungen.
