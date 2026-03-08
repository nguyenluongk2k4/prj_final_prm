-- Messages table for chat + realtime ordering

-- Message type enum
CREATE TYPE message_type AS ENUM ('text', 'image', 'file', 'voice');

-- Messages
CREATE TABLE public.messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  receiver_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  user1_id UUID NOT NULL,
  user2_id UUID NOT NULL,
  content TEXT,
  message_type message_type NOT NULL DEFAULT 'text',
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CHECK (user1_id < user2_id)
);

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- Basic development policies (align with relaxed RLS)
CREATE POLICY "Allow all select on messages"
  ON public.messages
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert on messages"
  ON public.messages
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update on messages"
  ON public.messages
  FOR UPDATE
  USING (true);

CREATE POLICY "Allow all delete on messages"
  ON public.messages
  FOR DELETE
  USING (true);

-- Set user1_id/user2_id consistently
CREATE OR REPLACE FUNCTION set_message_user_pair()
RETURNS TRIGGER AS $$
BEGIN
  NEW.user1_id := LEAST(NEW.sender_id, NEW.receiver_id);
  NEW.user2_id := GREATEST(NEW.sender_id, NEW.receiver_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_message_user_pair_trigger
  BEFORE INSERT ON public.messages
  FOR EACH ROW
  EXECUTE FUNCTION set_message_user_pair();

-- Indexes for chat ordering
CREATE INDEX messages_user_pair_idx ON public.messages(user1_id, user2_id, created_at DESC);
CREATE INDEX messages_sender_idx ON public.messages(sender_id);
CREATE INDEX messages_receiver_idx ON public.messages(receiver_id);

-- Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;

-- Friend list stats function
CREATE OR REPLACE FUNCTION public.get_friends_with_stats(p_user_id UUID)
RETURNS TABLE (
  friend_id UUID,
  name TEXT,
  avatar_url TEXT,
  status friend_status,
  created_at TIMESTAMPTZ,
  is_online BOOLEAN,
  last_active TIMESTAMPTZ,
  chat_count BIGINT,
  last_message_at TIMESTAMPTZ,
  has_reels BOOLEAN
)
LANGUAGE sql
STABLE
AS $$
  WITH friend_pairs AS (
    SELECT
      CASE
        WHEN user1_id = p_user_id THEN user2_id
        ELSE user1_id
      END AS friend_id,
      status,
      created_at
    FROM public.friends
    WHERE user1_id = p_user_id OR user2_id = p_user_id
  ),
  message_stats AS (
    SELECT
      CASE
        WHEN sender_id = p_user_id THEN receiver_id
        ELSE sender_id
      END AS friend_id,
      COUNT(*) AS chat_count,
      MAX(created_at) AS last_message_at
    FROM public.messages
    WHERE sender_id = p_user_id OR receiver_id = p_user_id
    GROUP BY friend_id
  )
  SELECT
    fp.friend_id,
    u.name,
    u.avatar_url,
    fp.status,
    fp.created_at,
    p.is_online,
    p.last_active,
    COALESCE(ms.chat_count, 0) AS chat_count,
    ms.last_message_at,
    EXISTS (
      SELECT 1
      FROM public.reels r
      WHERE r.author_id = fp.friend_id
    ) AS has_reels
  FROM friend_pairs fp
  JOIN public.users u ON u.id = fp.friend_id
  LEFT JOIN public.profiles p ON p.user_id = fp.friend_id
  LEFT JOIN message_stats ms ON ms.friend_id = fp.friend_id
  ORDER BY
    COALESCE(p.is_online, false) DESC,
    COALESCE(ms.chat_count, 0) DESC,
    ms.last_message_at DESC NULLS LAST,
    fp.created_at DESC;
$$;
