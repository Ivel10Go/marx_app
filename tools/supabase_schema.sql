-- Supabase schema for Marx app
-- Run in Supabase SQL editor

-- Users Profile
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  display_name text,
  email text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  deleted_at timestamp with time zone
);

-- Favorites
CREATE TABLE IF NOT EXISTS user_favorites (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id),
  quote_id text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  UNIQUE(user_id, quote_id)
);

-- Community submissions (bug reports and quote proposals)
CREATE TABLE IF NOT EXISTS community_submissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  submission_type text NOT NULL CHECK (submission_type IN ('bug_report', 'quote_submission')),
  title text,
  message text,
  quote_text text,
  author text,
  source text,
  details jsonb NOT NULL DEFAULT '{}'::jsonb,
  submitted_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  submitter_email text,
  platform text,
  app_version text,
  app_locale text,
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'reviewing', 'accepted', 'rejected', 'closed')),
  created_at timestamp with time zone DEFAULT now(),
  reviewed_at timestamp with time zone,
  reviewed_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  review_notes text
);

CREATE INDEX IF NOT EXISTS idx_community_submissions_type_status_created_at
  ON community_submissions(submission_type, status, created_at DESC);

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE community_submissions ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Users can view own favorites"
  ON user_favorites FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own favorites"
  ON user_favorites FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own favorites"
  ON user_favorites FOR DELETE
  USING (auth.uid() = user_id);

CREATE POLICY "Anyone can insert community submissions"
  ON community_submissions FOR INSERT
  WITH CHECK (true);
