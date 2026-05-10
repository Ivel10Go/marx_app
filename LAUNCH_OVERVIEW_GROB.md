# Marx App Launch-Status, grob erklärt

Stand: 10. Mai 2026

## Worum es hier geht

Diese Datei fasst den aktuellen Stand der App so zusammen, dass man schnell versteht:

- was schon fertig ist
- was noch offen ist
- was der Keystore und das Android-Signing bedeuten
- was als Nächstes sinnvoll ist

## Aktueller Gesamtstand

Die App ist auf Code-Ebene weitgehend fertig.

Das heißt:

- die wichtigsten Screens und Flows sind da
- Supabase-Login und Favoriten-Sync sind vorhanden
- der Datenschutz-Flow im Account-Bereich ist ergänzt
- das Android-Release-Signing ist vorbereitet

Noch nicht komplett abgeschlossen ist vor allem die externe Store-Seite, also Google Play Setup und die endgültige Release-Verifikation auf dem Ziel-Track.

## Was bereits erledigt ist

### App-Funktionalität

- Home, Archive, Favorites, Thinkers, Settings und Account sind vorhanden
- Favoriten können lokal gespeichert und mit Supabase synchronisiert werden
- Es gibt einen Account-Bereich mit Login, Logout, Sync und Datenschutz-Aktionen
- Die Checkliste wurde um den Datenschutz-Teil erweitert

### Datenschutz

Im Account-Bereich gibt es jetzt:

- Export der persönlichen Daten
- Löschen der lokalen Nutzerdaten
- Löschen der Cloud-Favoriten

Das ist noch nicht die komplette serverseitige Account-Löschung, aber ein sinnvoller MVP-Schritt für DSGVO.

### Android Signing

Für Android Release-Builds gibt es jetzt:

- eine Signing-Konfiguration in android/app/build.gradle.kts
- eine key.properties Datei im Projekt-Root
- eine Release-Keystore-Datei unter android/app/release.keystore

## Was der Keystore ist

Der Keystore ist eine Datei, mit der Android-Releases digital signiert werden.

Warum das wichtig ist:

- Google Play akzeptiert Release-Builds nur, wenn sie signiert sind
- die Signatur beweist, dass der Build von dir kommt
- ohne Keystore kann kein echter Release-AAB sauber veröffentlicht werden

In diesem Projekt ist der Release-Keystore lokal vorhanden und wird von Gradle verwendet.

Wichtig dabei:

- die Datei muss privat bleiben
- sie darf nicht ins Git-Repo
- sie ist nur für Release-Builds relevant

## Wo die Signing-Daten liegen

- android/app/build.gradle.kts: liest die Signing-Daten ein
- key.properties: enthält Alias, Passwort und Keystore-Dateiname
- android/app/release.keystore: die eigentliche Signaturdatei

## Was in key.properties steht

Dort sind die Werte für das Release-Signing abgelegt:

- storeFile
- storePassword
- keyAlias
- keyPassword

Diese Werte werden von Gradle gelesen, wenn ein Release-Build erstellt wird.

## Wie der Release-Build gedacht ist

Der Ablauf ist vereinfacht so:

1. Flutter erzeugt den Android-Build
2. Gradle nimmt die Release-Signing-Daten aus key.properties
3. Der Keystore signiert das Paket
4. Am Ende entsteht ein signierter AAB für Google Play

## Was ich zuletzt geprüft habe

Ich habe geprüft, dass:

- der Keystore existiert
- der Alias im Keystore vorhanden ist
- die Signing-Konfiguration im Android-Build bereits vorbereitet ist

Der Release-Build selbst konnte in dieser Session nicht vollständig bis zum Ende verifiziert werden, weil der laufende Gradle-Task nicht sauber mit einem Abschlussstatus zurückkam.

## Offene Punkte

### Noch offen für Phase 3.5

- serverseitige vollständige Auth-Account-Löschung
- falls gewünscht: Supabase Edge Function oder Backend-Endpoint dafür

### Noch offen für Phase 4

- Google Play Console App-Record
- In-App-Produkte in Google Play anlegen
- internes Test-Track-Setup
- finaler AAB-Upload und Test auf dem Play-Track

## Praktische Reihenfolge für jetzt

Wenn du einfach weitermachen willst, ist das die sinnvollste Reihenfolge:

1. Google Play Console anlegen bzw. prüfen.
2. In-App-Produkte mit den exakten Produkt-IDs erstellen.
3. Internal Testing Track aufsetzen und Test-Accounts eintragen.
4. `flutter build appbundle --release` erneut laufen lassen.
5. Das erzeugte AAB in den Test-Track hochladen.
6. Auf einem echten Android-Gerät installieren und den Kauf-/Restore-Flow testen.

## Warum die komplette Account-Löschung noch offen ist

Die Löschung eines Supabase-Auth-Users geht nicht sicher direkt aus der Flutter-App.

Grund:

- `supabase.auth.admin.deleteUser(...)` braucht den Secret-Key
- der Secret-Key darf niemals in die App
- deshalb muss die echte Account-Löschung serverseitig passieren, zum Beispiel über eine Edge Function oder ein kleines Backend

Was die App aktuell schon kann:

- lokale Nutzerdaten löschen
- Cloud-Favoriten löschen
- sich danach abmelden

Was noch fehlt, wenn DSGVO komplett sein soll:

- den Auth-User auf dem Server löschen
- optional auch weitere serverseitige Profile oder Logs entfernen

## Was du jetzt daraus mitnehmen kannst

Kurz gesagt:

- Die App ist code-seitig ziemlich weit
- Datenschutz-Export und lokale Löschung sind jetzt im Account-Bereich drin
- Android Release-Signing ist vorbereitet
- Der Keystore ist lokal vorhanden und nicht fürs Repo gedacht
- Der nächste echte große Schritt ist Google Play / Internal Testing

## Relevante Dateien

- [LAUNCH_CHECKLIST.md](LAUNCH_CHECKLIST.md)
- [android/app/build.gradle.kts](android/app/build.gradle.kts)
- [key.properties](key.properties)
- [android/app/release.keystore](android/app/release.keystore)
- [lib/presentation/account/account_screen.dart](lib/presentation/account/account_screen.dart)
- [lib/core/services/account_privacy_service.dart](lib/core/services/account_privacy_service.dart)

## Kurzfazit

Wenn man es grob sagt: Die App ist fast launchbereit, die wichtigsten App-Funktionen sind fertig, und das Android-Signing ist vorbereitet. Es fehlt jetzt vor allem noch die externe Store-Arbeit und die serverseitige Löschung, wenn du DSGVO komplett fertig machen willst.
