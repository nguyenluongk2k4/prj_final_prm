-- Relax unique constraints for development flexibility
-- Remove UNIQUE constraint on email to allow testing with duplicate emails

-- Drop UNIQUE constraint on users.email
ALTER TABLE public.users
DROP CONSTRAINT users_email_key;

-- Drop UNIQUE constraint on profiles.user_id (if multiple profiles per user needed for testing)
ALTER TABLE public.profiles
DROP CONSTRAINT profiles_user_id_key;

-- Clear existing test data to avoid conflicts
TRUNCATE TABLE public.user_preferences CASCADE;
TRUNCATE TABLE public.profiles CASCADE;
TRUNCATE TABLE public.users CASCADE;
