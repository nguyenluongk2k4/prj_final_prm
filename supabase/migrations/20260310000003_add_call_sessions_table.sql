-- Call sessions for Voice & Video calls
DO $$ BEGIN
    CREATE TYPE call_status AS ENUM ('init', 'ongoing', 'ended', 'missed', 'rejected');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE call_type AS ENUM ('voice', 'video');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

CREATE TABLE IF NOT EXISTS public.call_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  channel_name TEXT NOT NULL UNIQUE,
  caller_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  receiver_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  call_type call_type NOT NULL DEFAULT 'voice',
  status call_status NOT NULL DEFAULT 'init',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  ended_at TIMESTAMPTZ,
  token TEXT
);

ALTER TABLE public.call_sessions ENABLE ROW LEVEL SECURITY;

-- Basic development policies (relaxed for dev)
CREATE POLICY "Allow all select on call_sessions"
  ON public.call_sessions FOR SELECT USING (true);

CREATE POLICY "Allow all insert on call_sessions"
  ON public.call_sessions FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow all update on call_sessions"
  ON public.call_sessions FOR UPDATE USING (true);

CREATE POLICY "Allow all delete on call_sessions"
  ON public.call_sessions FOR DELETE USING (true);

-- Realtime
-- Check if table is already in publication to avoid error
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' 
        AND schemaname = 'public' 
        AND tablename = 'call_sessions'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.call_sessions;
    END IF;
END $$;
