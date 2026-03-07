-- Add status column to matches to preserve history without deleting records
ALTER TABLE public.matches 
ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'pending';

-- Add index for querying pending matches efficiently
CREATE INDEX IF NOT EXISTS matches_status_idx ON public.matches(status);
