-- Migration: Add function to get both matches and friends for conversations
-- Date: 2026-03-17

-- Create function to get conversations (matches + friends with messages)
CREATE OR REPLACE FUNCTION get_conversations_with_stats(p_user_id UUID)
RETURNS TABLE (
    conversation_id UUID,
    other_user_id UUID,
    name TEXT,
    avatar_url TEXT,
    conversation_type TEXT, -- 'match' or 'friend'
    status TEXT,
    created_at TIMESTAMPTZ,
    is_online BOOLEAN,
    last_active TIMESTAMPTZ,
    chat_count INTEGER,
    last_message_at TIMESTAMPTZ,
    last_message_type TEXT,
    last_message_content TEXT,
    last_message_sender_id UUID,
    has_reels BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    WITH matches_data AS (
        -- Get matches (people who liked each other but may not have chatted)
        SELECT 
            m.id as conversation_id,
            CASE 
                WHEN m.user1_id = p_user_id THEN m.user2_id 
                ELSE m.user1_id 
            END as other_user_id,
            p.name,
            p.avatar_url,
            'match'::TEXT as conversation_type,
            COALESCE(m.status, 'matched') as status,
            m.created_at,
            p.is_online,
            p.last_active,
            0 as chat_count, -- Will be updated below
            NULL::TIMESTAMPTZ as last_message_at,
            NULL::TEXT as last_message_type,
            NULL::TEXT as last_message_content,
            NULL::UUID as last_message_sender_id,
            FALSE as has_reels -- TODO: Add reels logic later
        FROM public.matches m
        JOIN public.profiles p ON (
            CASE 
                WHEN m.user1_id = p_user_id THEN p.user_id = m.user2_id 
                ELSE p.user_id = m.user1_id 
            END
        )
        WHERE m.user1_id = p_user_id OR m.user2_id = p_user_id
    ),
    friends_data AS (
        -- Get friends (people who have established friendship)
        SELECT 
            f.id as conversation_id,
            CASE 
                WHEN f.user1_id = p_user_id THEN f.user2_id 
                ELSE f.user1_id 
            END as other_user_id,
            p.name,
            p.avatar_url,
            'friend'::TEXT as conversation_type,
            f.status,
            f.created_at,
            p.is_online,
            p.last_active,
            0 as chat_count, -- Will be updated below
            NULL::TIMESTAMPTZ as last_message_at,
            NULL::TEXT as last_message_type,
            NULL::TEXT as last_message_content,
            NULL::UUID as last_message_sender_id,
            FALSE as has_reels
        FROM public.friends f
        JOIN public.profiles p ON (
            CASE 
                WHEN f.user1_id = p_user_id THEN p.user_id = f.user2_id 
                ELSE p.user_id = f.user1_id 
            END
        )
        WHERE (f.user1_id = p_user_id OR f.user2_id = p_user_id)
        AND f.status = 'accepted'
    ),
    all_conversations AS (
        -- Combine matches and friends, prioritizing friends over matches
        SELECT DISTINCT ON (other_user_id) *
        FROM (
            SELECT * FROM friends_data
            UNION ALL
            SELECT * FROM matches_data
        ) combined
        ORDER BY other_user_id, 
                 CASE WHEN conversation_type = 'friend' THEN 1 ELSE 2 END
    ),
    message_stats AS (
        -- Get message statistics for each conversation
        SELECT 
            CASE 
                WHEN sender_id = p_user_id THEN receiver_id 
                ELSE sender_id 
            END as other_user_id,
            COUNT(*) as message_count,
            MAX(created_at) as last_message_time,
            (array_agg(message_type ORDER BY created_at DESC))[1] as last_msg_type,
            (array_agg(content ORDER BY created_at DESC))[1] as last_msg_content,
            (array_agg(sender_id ORDER BY created_at DESC))[1] as last_msg_sender
        FROM public.messages 
        WHERE sender_id = p_user_id OR receiver_id = p_user_id
        GROUP BY CASE 
            WHEN sender_id = p_user_id THEN receiver_id 
            ELSE sender_id 
        END
    )
    SELECT 
        ac.conversation_id,
        ac.other_user_id,
        ac.name,
        ac.avatar_url,
        ac.conversation_type,
        ac.status,
        ac.created_at,
        ac.is_online,
        ac.last_active,
        COALESCE(ms.message_count::INTEGER, 0) as chat_count,
        ms.last_message_time as last_message_at,
        ms.last_msg_type as last_message_type,
        ms.last_msg_content as last_message_content,
        ms.last_msg_sender as last_message_sender_id,
        ac.has_reels
    FROM all_conversations ac
    LEFT JOIN message_stats ms ON ac.other_user_id = ms.other_user_id
    ORDER BY 
        -- Prioritize conversations with messages
        CASE WHEN ms.last_message_time IS NOT NULL THEN 1 ELSE 2 END,
        -- Then by last message time or creation time
        COALESCE(ms.last_message_time, ac.created_at) DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;