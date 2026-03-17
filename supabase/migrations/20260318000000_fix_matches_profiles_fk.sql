-- Fix: add unique constraint on profiles.user_id (if missing) then add FK
-- matches.user1_id / user2_id store auth user IDs = profiles.user_id

-- Ensure unique constraint exists on profiles.user_id
ALTER TABLE public.profiles
  DROP CONSTRAINT IF EXISTS profiles_user_id_key;

ALTER TABLE public.profiles
  ADD CONSTRAINT profiles_user_id_key UNIQUE (user_id);

-- Add FK from matches → profiles.user_id
ALTER TABLE public.matches
  ADD CONSTRAINT matches_user1_id_profiles_fkey
    FOREIGN KEY (user1_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE,
  ADD CONSTRAINT matches_user2_id_profiles_fkey
    FOREIGN KEY (user2_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;

-- Reload PostgREST schema cache
NOTIFY pgrst, 'reload schema';
