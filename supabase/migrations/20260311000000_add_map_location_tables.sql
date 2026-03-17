-- Map location tables for realtime tracking

CREATE TABLE public.user_locations (
  user_id UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  timestamp TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.match_locations (
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  match_id UUID NOT NULL REFERENCES public.matches(id) ON DELETE CASCADE,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, match_id)
);

ALTER TABLE public.user_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.match_locations ENABLE ROW LEVEL SECURITY;

-- RLS policies
-- user_locations: owners can write, connections (friends/matches) can read
CREATE POLICY "Users can read own or connected locations"
  ON public.user_locations
  FOR SELECT
  USING (
    auth.uid() = user_id
    OR EXISTS (
      SELECT 1
      FROM public.friends f
      WHERE f.status = 'accepted'
        AND (
          (f.user1_id = auth.uid() AND f.user2_id = user_id)
          OR (f.user2_id = auth.uid() AND f.user1_id = user_id)
        )
    )
    OR EXISTS (
      SELECT 1
      FROM public.matches m
      WHERE (m.user1_id = auth.uid() AND m.user2_id = user_id)
         OR (m.user2_id = auth.uid() AND m.user1_id = user_id)
    )
  );

CREATE POLICY "Users can insert own location"
  ON public.user_locations
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own location"
  ON public.user_locations
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own location"
  ON public.user_locations
  FOR DELETE
  USING (auth.uid() = user_id);

-- match_locations: match participants can read, owners can write
CREATE POLICY "Match participants can read match locations"
  ON public.match_locations
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM public.matches m
      WHERE m.id = match_id
        AND (m.user1_id = auth.uid() OR m.user2_id = auth.uid())
    )
  );

CREATE POLICY "Users can insert own match location"
  ON public.match_locations
  FOR INSERT
  WITH CHECK (
    auth.uid() = user_id
    AND EXISTS (
      SELECT 1
      FROM public.matches m
      WHERE m.id = match_id
        AND (m.user1_id = auth.uid() OR m.user2_id = auth.uid())
    )
  );

CREATE POLICY "Users can update own match location"
  ON public.match_locations
  FOR UPDATE
  USING (
    auth.uid() = user_id
    AND EXISTS (
      SELECT 1
      FROM public.matches m
      WHERE m.id = match_id
        AND (m.user1_id = auth.uid() OR m.user2_id = auth.uid())
    )
  )
  WITH CHECK (
    auth.uid() = user_id
    AND EXISTS (
      SELECT 1
      FROM public.matches m
      WHERE m.id = match_id
        AND (m.user1_id = auth.uid() OR m.user2_id = auth.uid())
    )
  );

CREATE POLICY "Users can delete own match location"
  ON public.match_locations
  FOR DELETE
  USING (
    auth.uid() = user_id
    AND EXISTS (
      SELECT 1
      FROM public.matches m
      WHERE m.id = match_id
        AND (m.user1_id = auth.uid() OR m.user2_id = auth.uid())
    )
  );

-- Indexes for map queries
CREATE INDEX user_locations_timestamp_idx
  ON public.user_locations(timestamp DESC);

CREATE INDEX match_locations_match_id_idx
  ON public.match_locations(match_id);

CREATE INDEX match_locations_match_id_timestamp_idx
  ON public.match_locations(match_id, timestamp DESC);

-- Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.user_locations;
ALTER PUBLICATION supabase_realtime ADD TABLE public.match_locations;
