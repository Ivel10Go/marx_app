# Paywall Style Spec (Zitate App)

## Ziel
Die Paywall soll sich wie ein natuerlicher Teil der App anfuehlen: broadsheet/editorial, ruhig, hochwertig, klarer Nutzen statt aggressivem Verkauf.

## Visuelle Sprache (aus bestehendem Design)
- Hintergrund: `AppColors.paper` (`#EDE8DF`)
- Primarfarbe/Accent: `AppColors.red` (`#C41E1E`) sparsam einsetzen
- Text primar: `AppColors.ink` (`#1A1A1A`)
- Text sekundar: `AppColors.inkLight` (`#555555`)
- Linien/Divider: `AppColors.rule` (`#BBB5AB`)
- Keine abgerundeten "mobile ad" Cards als Hauptlook; lieber klare Kanten und 1px Borders

## Typografie
- Headline: `GoogleFonts.playfairDisplay` (wie Masthead)
- UI/Kicker/Buttons: `GoogleFonts.ibmPlexSans`
- Paywall Titel: 30-34px, weight 700, leicht negativem letter spacing
- Section Kicker (z. B. "PRO") in Versalien, 9-11px, spacing 1.2-1.8
- Body copy: 11-13px, Zeilenhoehe 1.5-1.6

## Layout Struktur
1. Masthead Block oben
- Vollbreite auf `paper`
- Titel: `ZITATE APP PRO`
- Untertitel: 1 Zeile Value Proposition
- Rote Trennlinie (40x2)

2. Value Section
- 3 Benefit-Zeilen mit kurzer, konkreter Wirkung:
  - Tiefere Erklaerungen
  - Kuratierte Lernserien
  - Smart Reminder
- Jede Zeile als schlichte Row mit Icon links und Text rechts

3. Pricing Section
- Angebote als vertikale Liste (monatlich/jahrlich/lifetime)
- Jede Option: Border 1px, klarer Zustand fuer selected
- Recommended Badge nur fuer ein Paket (z. B. "EMPFOHLEN") in Rot
- Preis dominant, Periode sekundar

4. Action Section (sticky unten)
- Primar CTA: `PRO FREISCHALTEN` (rot gefuellt)
- Sekundaer: `KAEUFE WIEDERHERSTELLEN` (outline)
- Tertiaer Link: `Customer Center` (Textbutton)
- Rechtstext klein: "Jederzeit kuendbar. Abrechnung ueber App Store/Play Store."

## Komponenten-Stil
- Border Radius: 0-8 (nicht verspielt)
- Border: 1px `AppColors.ink` oder `AppColors.rule`
- Schatten nur sehr subtil oder gar nicht
- CTA Height: 44-48
- Vertikaler Rhythmus: 8 / 12 / 16 / 20 / 24

## Microcopy (Tonalitaet)
- Klar, respektvoll, nicht pushy
- Keine Fake-Dringlichkeit
- Beispiele:
  - Titel: "Mehr Tiefe mit Zitate App Pro"
  - Subtitle: "Fuer alle, die nicht nur lesen, sondern verstehen wollen."
  - CTA: "Pro freischalten"

## States
- Loading:
  - Skeleton oder ruhiger `CircularProgressIndicator`
  - Keine springenden Layout-Elemente
- Error (Offerings leer/Fehler):
  - Inline Hinweis in neutralem Ton
  - Retry Action sichtbar
- Already Pro:
  - Positive Confirmation Card oben
  - Fokus auf "Abo verwalten" und Customer Center

## Motion
- Enter Animation: leichtes Fade + 12px Slide-up (180-220ms)
- Keine stark federnden Animationen
- CTA state changes weich (100-150ms)

## Accessibility
- Kontrast >= WCAG AA
- Touch Targets >= 44px
- Semantische Labels fuer Package Cards und CTA Buttons
- Preise und Laufzeiten screen-reader freundlich ausgeben

## Flutter Umsetzungsnotizen
- Bestehende Datei als Basis: `lib/presentation/paywall/purchase_page.dart`
- Scaffold in App-Look angleichen:
  - Hintergrund auf `AppColors.paper`
  - Typografie via `GoogleFonts.playfairDisplay`/`GoogleFonts.ibmPlexSans`
  - Eigene PackageTile Komponente mit selected/recommended state
- CTA Bereich als `SafeArea`-Bottom-Container statt mitten im Scrollbereich
- Restore und Customer Center klar getrennt halten

## Definition of Done (Design)
- Paywall fuehlt sich visuell wie Home/Settings an
- Genau ein klarer primarer CTA
- Pakete sind in <3 Sekunden vergleichbar
- Kein UI-Element wirkt wie Fremd-SDK-Default
- Pro-Status und Fehlerfaelle sind sauber gestaltet
