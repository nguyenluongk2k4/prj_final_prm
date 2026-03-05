-- 1. Drop the foreign key from user_preferences
ALTER TABLE public.user_preferences DROP CONSTRAINT user_preferences_preference_id_fkey;

-- 2. Change preferences.id to TEXT
ALTER TABLE public.preferences ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.preferences ALTER COLUMN id TYPE TEXT USING id::text;

-- 3. Change user_preferences.preference_id to TEXT
ALTER TABLE public.user_preferences ALTER COLUMN preference_id TYPE TEXT USING preference_id::text;

-- 3.5 Add translation_key to preferences
ALTER TABLE public.preferences ADD COLUMN IF NOT EXISTS translation_key TEXT;

-- 4. Re-add the foreign key
ALTER TABLE public.user_preferences ADD CONSTRAINT user_preferences_preference_id_fkey FOREIGN KEY (preference_id) REFERENCES public.preferences(id) ON DELETE CASCADE;

-- 5. Insert default preferences so foreign key references are valid when frontend sends string ids
INSERT INTO public.preferences (id, name, icon, translation_key) VALUES 
('photography', 'Photography', 'camera', 'photography'),
('shopping', 'Shopping', 'shopping', 'shopping'),
('karaoke', 'Karaoke', 'voice', 'karaoke'),
('yoga', 'Yoga', 'yoga', 'yoga'),
('cooking', 'Cooking', 'noodles', 'cooking'),
('tennis', 'Tennis', 'tennis', 'tennis'),
('run', 'Run', 'sport', 'run'),
('swimming', 'Swimming', 'ripple', 'swimming'),
('art', 'Art', 'platte', 'art'),
('traveling', 'Traveling', 'outdoor', 'traveling'),
('extreme', 'Extreme', 'parachute', 'extreme'),
('music', 'Music', 'music', 'music'),
('drink', 'Drink', 'goblet', 'drink'),
('videoGames', 'Video games', 'gameHandle', 'videoGames')
ON CONFLICT (id) DO NOTHING;

-- 6. Update the RPC to use the new exact string ID instead of name to match frontend formats
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
        -- array of preference string IDs for the front-end string matching
        ARRAY(
            SELECT up.preference_id 
            FROM public.user_preferences up
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
