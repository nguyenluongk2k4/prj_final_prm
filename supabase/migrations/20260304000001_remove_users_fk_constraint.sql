-- Remove Foreign Key Constraint from users table
-- This allows users table to be created independently from auth.users
-- Sync is handled by Supabase automatically, no constraint needed

-- Drop the foreign key constraint
ALTER TABLE public.users
DROP CONSTRAINT users_id_fkey;
