-- Relax RLS Policies for Development
-- This allows all operations for easier testing
-- DO NOT use in production!

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own record" ON public.users;
DROP POLICY IF EXISTS "Users can insert own record" ON public.users;
DROP POLICY IF EXISTS "Users can update own record" ON public.users;

DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;

DROP POLICY IF EXISTS "Anyone can view preferences" ON public.preferences;

DROP POLICY IF EXISTS "Users can view own preferences" ON public.user_preferences;
DROP POLICY IF EXISTS "Users can insert own preferences" ON public.user_preferences;
DROP POLICY IF EXISTS "Users can manage own preferences" ON public.user_preferences;

DROP POLICY IF EXISTS "Users can view own swipes" ON public.swipes;
DROP POLICY IF EXISTS "Users can create swipes" ON public.swipes;

DROP POLICY IF EXISTS "Users can view matches" ON public.matches;

DROP POLICY IF EXISTS "Users can view reels" ON public.reels;
DROP POLICY IF EXISTS "Users can create reels" ON public.reels;
DROP POLICY IF EXISTS "Users can update own reels" ON public.reels;
DROP POLICY IF EXISTS "Users can delete own reels" ON public.reels;

DROP POLICY IF EXISTS "Users can view reel likes" ON public.reel_likes;
DROP POLICY IF EXISTS "Users can manage own reel likes" ON public.reel_likes;

-- Create new permissive policies for all tables (allow all operations)

-- Users table - allow all
CREATE POLICY "Allow all select on users"
  ON public.users
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert on users"
  ON public.users
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update on users"
  ON public.users
  FOR UPDATE
  USING (true);

CREATE POLICY "Allow all delete on users"
  ON public.users
  FOR DELETE
  USING (true);

-- Profiles table - allow all
CREATE POLICY "Allow all select on profiles"
  ON public.profiles
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert on profiles"
  ON public.profiles
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update on profiles"
  ON public.profiles
  FOR UPDATE
  USING (true);

CREATE POLICY "Allow all delete on profiles"
  ON public.profiles
  FOR DELETE
  USING (true);

-- Preferences table - allow all
CREATE POLICY "Allow all select on preferences"
  ON public.preferences
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert on preferences"
  ON public.preferences
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update on preferences"
  ON public.preferences
  FOR UPDATE
  USING (true);

CREATE POLICY "Allow all delete on preferences"
  ON public.preferences
  FOR DELETE
  USING (true);

-- User preferences table - allow all
CREATE POLICY "Allow all select on user_preferences"
  ON public.user_preferences
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert on user_preferences"
  ON public.user_preferences
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update on user_preferences"
  ON public.user_preferences
  FOR UPDATE
  USING (true);

CREATE POLICY "Allow all delete on user_preferences"
  ON public.user_preferences
  FOR DELETE
  USING (true);

-- Swipes table - allow all
CREATE POLICY "Allow all select on swipes"
  ON public.swipes
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert on swipes"
  ON public.swipes
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update on swipes"
  ON public.swipes
  FOR UPDATE
  USING (true);

CREATE POLICY "Allow all delete on swipes"
  ON public.swipes
  FOR DELETE
  USING (true);

-- Matches table - allow all
CREATE POLICY "Allow all select on matches"
  ON public.matches
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert on matches"
  ON public.matches
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update on matches"
  ON public.matches
  FOR UPDATE
  USING (true);

CREATE POLICY "Allow all delete on matches"
  ON public.matches
  FOR DELETE
  USING (true);

-- Reels table - allow all
CREATE POLICY "Allow all select on reels"
  ON public.reels
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert on reels"
  ON public.reels
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update on reels"
  ON public.reels
  FOR UPDATE
  USING (true);

CREATE POLICY "Allow all delete on reels"
  ON public.reels
  FOR DELETE
  USING (true);

-- Reel likes table - allow all
CREATE POLICY "Allow all select on reel_likes"
  ON public.reel_likes
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert on reel_likes"
  ON public.reel_likes
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update on reel_likes"
  ON public.reel_likes
  FOR UPDATE
  USING (true);

CREATE POLICY "Allow all delete on reel_likes"
  ON public.reel_likes
  FOR DELETE
  USING (true);
