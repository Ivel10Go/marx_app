# Supabase Setup Guide — Marx App

**Ziel:** Supabase Backend mit Auth, Database, RLS konfigurieren für optionales User-Account-System.

**Zeit:** ~20-30 Minuten für Setup, ~1 Stunde für Database-Schema + RLS.

---

## Phase 1: Supabase Konto & Projekt (5 min)

### 1.1 Supabase Account erstellen
1. Gehe zu [supabase.com](https://supabase.com)
2. "Start Your Project" → "Sign Up"
3. Authentifizierung mit GitHub oder E-Mail
4. Email verifizieren

### 1.2 Neues Projekt erstellen
1. Dashboard → "New Project"
2. **Name:** `Marx Zitatatlas`
3. **Database Password:** Stark (Auto-generiert ist OK) — Speichern als `DB_PASSWORD`
4. **Region:** Closest zu dir (z.B. Frankfurt für Europa)
5. **Pricing:** Free Tier (reicht für MVP)
6. Warten auf Initialisierung (~1 Min)

### 1.3 Projekt-Credentials kopieren
Nach Projekt-Erstellung:
1. Gehe zu **Settings** → **API**
2. Kopiere:
   - **Project URL:** `https://xxxxx.supabase.co` → `SUPABASE_URL`
   - **Anon Key:** (öffentlicher Key) → `SUPABASE_ANON_KEY`
   - **Service Role Key:** (privater Key, für Server) → Sicher speichern
3. Speichern für später (Flutter Integration)

---

## Phase 2: Database Schema & RLS (20 min)

### 2.1 SQL Editor öffnen
1. Dashboard → **SQL Editor**
2. **New Query**

### 2.2 Schema: Profiles Table
Kopiere dieses SQL in den Editor:

```sql
-- Profiles Table
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  display_name TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP WITH TIME ZONE
);

-- Auto-Insert Profile on User Creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email)
  VALUES (new.id, new.email);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

Klicke **Run** um auszuführen. ✅ Sollte ohne Fehler durchlaufen.

### 2.3 Schema: User Favorites Table
```sql
-- User Favorites Table
CREATE TABLE public.user_favorites (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  quote_id TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  
  UNIQUE(user_id, quote_id)
);

CREATE INDEX idx_user_favorites_user_id ON public.user_favorites(user_id);
CREATE INDEX idx_user_favorites_quote_id ON public.user_favorites(quote_id);
```

Klicke **Run**. ✅

### 2.4 Row Level Security (RLS) — Aktivieren

```sql
-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_favorites ENABLE ROW LEVEL SECURITY;

-- Profiles: Users können nur ihr Profil sehen/ändern
CREATE POLICY "Users can view own profile"
  ON public.profiles
  FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.profiles
  FOR UPDATE
  USING (auth.uid() = id);

-- Favorites: Users können nur ihre Favoriten sehen
CREATE POLICY "Users can view own favorites"
  ON public.user_favorites
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own favorites"
  ON public.user_favorites
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own favorites"
  ON public.user_favorites
  FOR DELETE
  USING (auth.uid() = user_id);

-- Service Role: Backend kann alles
CREATE POLICY "Service role can do everything on profiles"
  ON public.profiles
  FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role can do everything on favorites"
  ON public.user_favorites
  FOR ALL
  USING (auth.role() = 'service_role');
```

Klicke **Run**. ✅ RLS ist jetzt aktiv.

---

## Phase 3: Authentication konfigurieren (10 min)

### 3.1 Authentifizierung Providers aktivieren
1. Dashboard → **Authentication** → **Providers**
2. Aktiviere:
   - ✅ **Email** (Default, bereits an)
   - ⭕ **Google** (Optional für Phase 2)
   - ⭕ **Apple** (Optional, iOS-only)

### 3.2 Email Settings
1. **Authentication** → **Email Templates**
2. **Confirm signup** — Template anschauen (sollte OK sein)
3. **Reset Password** — Template anschauen
4. Nichts ändern, Defaults sind gut

### 3.3 Redirect URLs
1. **Authentication** → **URL Configuration**
2. **Site URL:** (wird später gesetzt, für Production)
3. **Redirect URLs:**
   ```
   com.marxapp.zitatatlas://auth/callback
   marxzitatatlas://auth/callback
   ```
   (Für Android und iOS Deep Linking)

---

## Phase 4: Umgebungsvariablen in Flutter (5 min)

### 4.1 Environment File erstellen
Erstelle `.env` in Projekt-Root:

```
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGc...
```

(Ersetze mit deinen echten Werten von Phase 1.3)

### 4.2 Flutter Integration — main.dart
Öffne [lib/main.dart](lib/main.dart) und füge diese Zeilen vor `runApp()` ein:

```dart
await Supabase.initialize(
  url: 'https://xxxxx.supabase.co',  // Oder aus .env laden
  anonKey: 'eyJhbGc...',              // Oder aus .env laden
);
```

Oder noch besser — mit flutter_dotenv:

```bash
flutter pub add flutter_dotenv
```

Dann in main.dart:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load();
  
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
  // ... rest der Bootstrap
}
```

### 4.3 Pubspec.yaml Check
```bash
flutter pub get
```

Sollte `supabase_flutter` installieren. ✅

---

## Phase 5: Test — Supabase Console (5 min)

### 5.1 Test User erstellen
1. Dashboard → **Authentication** → **Users**
2. **Add user** → Add new user manually
3. Email: `test@example.com`
4. Password: `TestPassword123!`
5. Auto confirm: ✅
6. **Create user**

### 5.2 Test in SQL
```sql
SELECT * FROM public.profiles;
```

Du solltest einen Row mit:
- `id`: (UUID des Test-Users)
- `email`: `test@example.com`

Wenn nicht, dann `handle_new_user()` Trigger nicht ausgeführt. Prüfen!

### 5.3 Favoriten Test
```sql
INSERT INTO public.user_favorites (user_id, quote_id)
VALUES ('<test-user-id-hier>', 1);

SELECT * FROM public.user_favorites;
```

Sollte 1 Row zeigen. ✅

---

## Phase 6: RLS Sicherheitstest (5 min)

### 6.1 RLS Test im SQL Editor
```sql
-- Als Anon-User (nicht angemeldet)
-- Sollte KEINE Favoriten sehen:
SET ROLE anon;
SELECT * FROM public.user_favorites;
```

Sollte 0 Rows zeigen (RLS sperrt es). ✅

---

## Nächste Schritte

✅ **Supabase Setup fertig!**

**Dann starten:**
1. [ ] Flutter App integrieren mit `supabase_flutter`
2. [ ] SupabaseAuthService testen (unit tests)
3. [ ] Login/Signup UI in Settings Screen
4. [ ] Favoriten-Sync implementieren
5. [ ] RevenueCat + Supabase Login verbinden

---

## Troubleshooting

### Problem: "RLS violation"
**Lösung:** Prüfe dass `set_config('request.jwt.claims', jwt, false)` in RLS Policies funktioniert.
```sql
-- Manuell Test
SELECT * FROM public.profiles WHERE id = auth.uid();
```

### Problem: "Email already exists"
**Lösung:** Email-Uniqueness ist default. Test-Email ändern oder User in Console löschen.

### Problem: "Invalid JWT"
**Lösung:** Session abgelaufen. App neustarten oder `Supabase.instance.auth.refreshSession()` aufrufen.

---

## Sicherheit — WICHTIG!

⚠️ **Niemals**:
- Anon Key in Version Control committen
- Service Role Key in Flutter Code
- Credentials hart-coden

✅ **Immer**:
- .env in .gitignore
- Secrets in Production Environment Variables
- RLS Policies für sensible Daten

---

**Support:**
- [Supabase Docs](https://supabase.com/docs)
- [Supabase Discord](https://discord.supabase.com)
- [Flutter Integration Guide](https://supabase.com/docs/reference/flutter/introduction)
