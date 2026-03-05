-- Function to fetch a batch of discoverable profiles
-- Filters out the user themselves, users they've already swiped, and matches target gender.

DROP FUNCTION IF EXISTS get_discover_profiles(uuid, integer, integer);

CREATE OR REPLACE FUNCTION get_discover_profiles(p_user_id UUID, p_limit INT, p_offset INT)
RETURNS TABLE (
    id UUID,
    email TEXT,
    name TEXT,
    phone TEXT,
    avatar_url TEXT,
    preferences TEXT[],
    gender TEXT,
    target_gender TEXT,
    bio TEXT,
    birth_date DATE,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    province_id INT,
    is_online BOOLEAN,
    last_active TIMESTAMPTZ,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
) AS $$
DECLARE
    v_user_gender TEXT;
    v_user_target_gender TEXT;
BEGIN
    -- Fetch the requesting user's gender and target_gender
    SELECT p.gender, p.target_gender INTO v_user_gender, v_user_target_gender
    FROM public.profiles p
    WHERE p.user_id = p_user_id;

    RETURN QUERY
    SELECT 
        u.id,
        u.email,
        u.name,
        u.phone,
        p.avatar_url,
        -- array of preference names
        ARRAY(
            SELECT pref.name 
            FROM public.user_preferences up
            JOIN public.preferences pref ON up.preference_id = pref.id
            WHERE up.user_id = u.id
        ) as preferences,
        p.gender,
        p.target_gender,
        p.bio,
        p.birth_date,
        p.latitude,
        p.longitude,
        p.province_id,
        p.is_online,
        p.last_active,
        u.created_at,
        u.updated_at
    FROM public.users u
    JOIN public.profiles p ON u.id = p.user_id
    WHERE 
        u.id != p_user_id -- Exclude self
        AND (
            v_user_target_gender IS NULL 
            OR p.gender = v_user_target_gender -- Candidate's gender matches what user wants
        )
        AND (
            p.target_gender IS NULL
            OR p.target_gender = v_user_gender -- Candidate wants user's gender
        )
        -- Exclude users already swiped by this user
        AND NOT EXISTS (
            SELECT 1 
            FROM public.swipes s 
            WHERE s.swiper_id = p_user_id AND s.swiped_id = u.id
        )
    ORDER BY p.last_active DESC NULLS LAST
    LIMIT p_limit
    OFFSET p_offset;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
