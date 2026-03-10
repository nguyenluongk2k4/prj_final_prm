-- Add thumbnail_url to reels table
ALTER TABLE public.reels ADD COLUMN IF NOT EXISTS thumbnail_url TEXT;

-- Update RLS policies for reels (if needed, but usually select is public or depends on friendships)
-- For now, let's make it public read for simplicity in discovery
CREATE POLICY "Anyone can view reels" ON public.reels
FOR SELECT USING (true);
