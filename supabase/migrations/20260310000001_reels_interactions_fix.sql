-- Migration: Add reel_comments table and update counters
-- Created: 2026-03-10

-- 1. Create reel_comments table
CREATE TABLE IF NOT EXISTS public.reel_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reel_id UUID NOT NULL REFERENCES public.reels(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Enable RLS
ALTER TABLE public.reels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reel_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reel_comments ENABLE ROW LEVEL SECURITY;

-- 3. RLS Policies
-- Reels: Select already handled as true in previous migration, but ensuring consistency
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Anyone can view reels') THEN
        CREATE POLICY "Anyone can view reels" ON public.reels FOR SELECT USING (true);
    END IF;
END $$;

-- Reel Likes: Select is public, Insert/Delete is own
CREATE POLICY "Anyone can view reel likes" ON public.reel_likes FOR SELECT USING (true);
CREATE POLICY "Users can manage own likes" ON public.reel_likes 
  FOR ALL USING (auth.uid() = user_id);

-- Reel Comments: Select is public, Insert is own, Delete is own
CREATE POLICY "Anyone can view reel comments" ON public.reel_comments FOR SELECT USING (true);
CREATE POLICY "Users can post comments" ON public.reel_comments 
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can manage own comments" ON public.reel_comments 
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own comments" ON public.reel_comments 
  FOR DELETE USING (auth.uid() = user_id);

-- 4. Triggers to update counts
-- Function to update counts
CREATE OR REPLACE FUNCTION public.update_reel_counts()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        IF (TG_TABLE_NAME = 'reel_likes') THEN
            UPDATE public.reels SET likes_count = likes_count + 1 WHERE id = NEW.reel_id;
        ELSIF (TG_TABLE_NAME = 'reel_comments') THEN
            UPDATE public.reels SET comments_count = comments_count + 1 WHERE id = NEW.reel_id;
        END IF;
    ELSIF (TG_OP = 'DELETE') THEN
        IF (TG_TABLE_NAME = 'reel_likes') THEN
            UPDATE public.reels SET likes_count = likes_count - 1 WHERE id = OLD.reel_id;
        ELSIF (TG_TABLE_NAME = 'reel_comments') THEN
            UPDATE public.reels SET comments_count = comments_count - 1 WHERE id = OLD.reel_id;
        END IF;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create triggers
DROP TRIGGER IF EXISTS trigger_update_likes_count ON public.reel_likes;
CREATE TRIGGER trigger_update_likes_count
AFTER INSERT OR DELETE ON public.reel_likes
FOR EACH ROW EXECUTE FUNCTION public.update_reel_counts();

DROP TRIGGER IF EXISTS trigger_update_comments_count ON public.reel_comments;
CREATE TRIGGER trigger_update_comments_count
AFTER INSERT OR DELETE ON public.reel_comments
FOR EACH ROW EXECUTE FUNCTION public.update_reel_counts();
