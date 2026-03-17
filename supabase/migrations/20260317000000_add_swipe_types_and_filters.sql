-- Migration: Add swipe_type column and enhanced filtering
-- Date: 2026-03-17

-- 1. Add swipe_type column to swipes table (safe for re-run)
ALTER TABLE public.swipes 
ADD COLUMN IF NOT EXISTS swipe_type text NOT NULL DEFAULT 'like';

-- 2. Add check constraint (safe for re-run)
DO $$
BEGIN
    ALTER TABLE public.swipes 
    ADD CONSTRAINT swipes_swipe_type_check 
    CHECK (swipe_type IN ('like', 'dislike', 'superlike'));
EXCEPTION 
    WHEN duplicate_object THEN NULL;
END $$;

-- 3. Backfill swipe_type from is_like column (only update when needed)
UPDATE public.swipes 
SET swipe_type = CASE 
    WHEN is_like = true THEN 'like' 
    ELSE 'dislike' 
END
WHERE swipe_type = 'like'; -- Only update default values

-- 4. Update the trigger function check_and_create_match()
CREATE OR REPLACE FUNCTION check_and_create_match()
RETURNS TRIGGER AS $$
BEGIN
    -- Only process like and superlike swipes
    IF NEW.swipe_type NOT IN ('like', 'superlike') THEN
        RETURN NEW;
    END IF;

    -- Check if the swiped user has also liked/superliked the swiper
    IF EXISTS (
        SELECT 1 FROM public.swipes 
        WHERE swiper_id = NEW.swiped_id 
        AND swiped_id = NEW.swiper_id 
        AND swipe_type IN ('like', 'superlike')
    ) THEN
        -- Create match if both users liked/superliked each other
        INSERT INTO public.matches (user1_id, user2_id, created_at)
        VALUES (
            LEAST(NEW.swiper_id, NEW.swiped_id),
            GREATEST(NEW.swiper_id, NEW.swiped_id),
            NOW()
        )
        ON CONFLICT (user1_id, user2_id) DO NOTHING;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Create enhanced discover function with filters
CREATE OR REPLACE FUNCTION get_discover_profiles_v2(
    p_user_id UUID, 
    p_limit INT, 
    p_offset INT,
    p_distance_km DOUBLE PRECISION DEFAULT NULL,
    p_age_min INT DEFAULT NULL,
    p_age_max INT DEFAULT NULL,
    p_target_gender TEXT DEFAULT NULL
)
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
    v_user_lat DOUBLE PRECISION;
    v_user_lon DOUBLE PRECISION;
BEGIN
    -- Fetch the requesting user's info
    SELECT p.gender, p.target_gender, p.latitude, p.longitude 
    INTO v_user_gender, v_user_target_gender, v_user_lat, v_user_lon
    FROM public.profiles p
    WHERE p.user_id = p_user_id;

    -- Override target gender if provided in parameters
    IF p_target_gender IS NOT NULL THEN
        v_user_target_gender := p_target_gender;
    END IF;

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
        -- Filter by age if specified
        AND (
            p_age_min IS NULL 
            OR p.birth_date IS NULL 
            OR DATE_PART('year', AGE(p.birth_date)) >= p_age_min
        )
        AND (
            p_age_max IS NULL 
            OR p.birth_date IS NULL 
            OR DATE_PART('year', AGE(p.birth_date)) <= p_age_max
        )
        -- Filter by distance if specified and location data is available
        AND (
            p_distance_km IS NULL 
            OR v_user_lat IS NULL 
            OR v_user_lon IS NULL 
            OR p.latitude IS NULL 
            OR p.longitude IS NULL
            OR (
                6371 * acos(
                    cos(radians(v_user_lat)) * 
                    cos(radians(p.latitude)) * 
                    cos(radians(p.longitude) - radians(v_user_lon)) + 
                    sin(radians(v_user_lat)) * 
                    sin(radians(p.latitude))
                ) <= p_distance_km
            )
        )
    ORDER BY p.last_active DESC NULLS LAST
    LIMIT p_limit
    OFFSET p_offset;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 6. Grant permissions
GRANT EXECUTE ON FUNCTION get_discover_profiles_v2 TO authenticated;