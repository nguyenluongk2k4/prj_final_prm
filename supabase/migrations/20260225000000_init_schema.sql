-- Tự động thêm Extension PostgreSQL dành cho GIS/Bản đồ
CREATE EXTENSION IF NOT EXISTS postgis;

-- 0. Bảng users: Mở rộng Supabase auth.users với thông tin hồ sơ
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  name TEXT,
  phone TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- 1. Bảng lưu trữ thông tin cá nhân (Profiles)
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES public.users(id) ON DELETE CASCADE,
  display_name TEXT NOT NULL,
  bio TEXT,
  gender TEXT,
  target_gender TEXT, -- Đối tượng muốn tìm kiếm
  birth_date DATE,
  -- Lưu vị trí người dùng dưới dạng tọa độ địa lý (kinh độ, vĩ độ)
  location geography(POINT),
  avatar_url TEXT,
  
  -- Tracking Status & Pump-like Map Tracker
  is_online BOOLEAN DEFAULT FALSE,
  last_active TIMESTAMPTZ DEFAULT NOW(),

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 2. Bảng lưu trữ Preferences/Sở thích (Interests)
CREATE TABLE public.preferences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  icon TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.preferences ENABLE ROW LEVEL SECURITY;

-- 3. Bảng nối giữa users và preferences (Many-to-Many)
CREATE TABLE public.user_preferences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  preference_id UUID NOT NULL REFERENCES public.preferences(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, preference_id)
);

ALTER TABLE public.user_preferences ENABLE ROW LEVEL SECURITY;

-- 4. Bảng lưu trữ hành động quẹt (Swipes)
CREATE TABLE public.swipes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  swiper_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  swiped_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  is_like BOOLEAN NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  -- Đảm bảo 1 user chỉ quẹt 1 user khác 1 lần
  UNIQUE(swiper_id, swiped_id)
);

ALTER TABLE public.swipes ENABLE ROW LEVEL SECURITY;

-- 5. Bảng lưu trữ những người dùng đã kết đôi (Matches)
CREATE TABLE public.matches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user1_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  user2_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  -- Đảm bảo user1_id luôn nhỏ hơn user2_id để tránh records bị đảo ngược
  CHECK (user1_id < user2_id),
  UNIQUE (user1_id, user2_id)
);

ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;

-- Function trigger auto_match: 
-- Khi một swipe (is_like = true) được push vào, kiểm tra chiều ngược lại đã is_like = true chưa
CREATE OR REPLACE FUNCTION check_and_create_match()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.is_like = TRUE THEN
    IF EXISTS (
      SELECT 1 FROM public.swipes
      WHERE swiper_id = NEW.swiped_id 
        AND swiped_id = NEW.swiper_id 
        AND is_like = TRUE
    ) THEN
      -- Nếu có match thì tự động thêm vào bảng Matches
      INSERT INTO public.matches (user1_id, user2_id)
      VALUES (
        LEAST(NEW.swiper_id, NEW.swiped_id),
        GREATEST(NEW.swiper_id, NEW.swiped_id)
      ) ON CONFLICT DO NOTHING;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_create_match
AFTER INSERT ON public.swipes
FOR EACH ROW EXECUTE FUNCTION check_and_create_match();

-- 6. Bảng lưu trữ tính năng Reels / Ngắn (Short Videos)
CREATE TABLE public.reels (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  video_url TEXT NOT NULL,
  description TEXT,
  likes_count INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.reels ENABLE ROW LEVEL SECURITY;

-- 7. Bảng lưu trữ Like cho Reel
CREATE TABLE public.reel_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reel_id UUID REFERENCES public.reels(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(reel_id, user_id)
);

ALTER TABLE public.reel_likes ENABLE ROW LEVEL SECURITY;

-- ===== RLS Policies =====

-- Users can only read/update their own record
CREATE POLICY "Users can view own record"
  ON public.users
  FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own record"
  ON public.users
  FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own record"
  ON public.users
  FOR UPDATE
  USING (auth.uid() = id);

-- Profiles - similar RLS
CREATE POLICY "Users can view own profile"
  ON public.profiles
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own profile"
  ON public.profiles
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own profile"
  ON public.profiles
  FOR UPDATE
  USING (auth.uid() = user_id);

-- Preferences - public read
CREATE POLICY "Anyone can view preferences"
  ON public.preferences
  FOR SELECT
  USING (true);

-- User preferences - users can manage their own
CREATE POLICY "Users can view own preferences"
  ON public.user_preferences
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own preferences"
  ON public.user_preferences
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own preferences"
  ON public.user_preferences
  FOR UPDATE
  USING (auth.uid() = user_id);

-- Bật Realtime trên db để có thể track vị trí
ALTER PUBLICATION supabase_realtime ADD TABLE public.profiles;
ALTER PUBLICATION supabase_realtime ADD TABLE public.swipes;
ALTER PUBLICATION supabase_realtime ADD TABLE public.matches;
