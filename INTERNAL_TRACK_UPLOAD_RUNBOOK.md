# Internal Track Upload Runbook (Android)

Status: vorbereitet
Hinweis: Developer-Account Schritt bleibt bewusst der letzte Schritt.

## Artefakt

- Datei: build/app/outputs/bundle/release/app-release.aab
- Branch: release/may-2026

## Vor dem Upload

- [ ] Play Console Zugriff vorhanden
- [ ] App-Eintrag angelegt
- [ ] Privacy Policy URL gesetzt
- [ ] Kontakt-E-Mail gesetzt
- [ ] Content Rating Fragebogen ausgefuellt
- [ ] Store-Listing-Texte aus tools/playstore_metadata.md uebernommen

## Upload-Schritte (Internal Testing)

1. Play Console -> App -> Testing -> Internal testing
2. Neue Release erstellen
3. `app-release.aab` hochladen
4. Release Notes (DE) eintragen
5. Save -> Review release -> Start rollout to Internal testing

## Tester-Setup

- [ ] Testliste (Google-Konten) gepflegt
- [ ] Opt-in Link erzeugt
- [ ] Link an Tester versendet

## Validierung nach Upload

- [ ] Build in Internal Track sichtbar
- [ ] Install auf Pixel6 erfolgreich
- [ ] Paywall + Purchase + Restore getestet
- [ ] Login + Favorites Sync getestet
- [ ] Ergebnis in TEST_RUNBOOK_PIXEL6_FINAL_QA.md dokumentiert

## Exit-Kriterium

- Internal Track laeuft stabil mit mindestens einem vollstaendigen Pixel6-Testlauf ohne Blocker.
