-- Update friend list stats to include last message content/type/sender

DROP FUNCTION IF EXISTS public.get_friends_with_stats(UUID);

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
  last_message_content TEXT,
  last_message_type message_type,
  last_message_sender_id UUID,
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
      COUNT(*) AS chat_count
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
    lm.created_at AS last_message_at,
    lm.content AS last_message_content,
    lm.message_type AS last_message_type,
    lm.sender_id AS last_message_sender_id,
    EXISTS (
      SELECT 1
      FROM public.reels r
      WHERE r.author_id = fp.friend_id
    ) AS has_reels
  FROM friend_pairs fp
  JOIN public.users u ON u.id = fp.friend_id
  LEFT JOIN public.profiles p ON p.user_id = fp.friend_id
  LEFT JOIN message_stats ms ON ms.friend_id = fp.friend_id
  LEFT JOIN LATERAL (
    SELECT m.content, m.message_type, m.sender_id, m.created_at
    FROM public.messages m
    WHERE (m.sender_id = p_user_id AND m.receiver_id = fp.friend_id)
       OR (m.sender_id = fp.friend_id AND m.receiver_id = p_user_id)
    ORDER BY m.created_at DESC
    LIMIT 1
  ) lm ON true
  ORDER BY
    COALESCE(p.is_online, false) DESC,
    COALESCE(ms.chat_count, 0) DESC,
    lm.created_at DESC NULLS LAST,
    fp.created_at DESC;
$$;
