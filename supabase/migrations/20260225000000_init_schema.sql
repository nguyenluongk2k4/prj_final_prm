-- Tự động thêm Extension PostgreSQL dành cho GIS/Bản đồ
CREATE EXTENSION IF NOT EXISTS postgis;

-- 1. Bảng lưu trữ thông tin cá nhân (Profiles)
CREATE TABLE public.profiles (
  -- Sử dụng Fireabase UID (Dạng text ngẫu nhiên 28-128 chars)
  id VARCHAR(128) PRIMARY KEY,
  display_name TEXT NOT NULL,
  bio TEXT,
  gender TEXT,
  target_gender TEXT, -- Đối tượng muốn tìm kiếm kiếm
  birth_date DATE,
  -- Lưu vị trí người dùng dưới dạng tọa độ địa lý (kinh độ, vĩ độ)
  location geography(POINT),
  avatar_url TEXT,
  
  -- [NEW] Tracking Status & Pump-like Map Tracker
  is_online BOOLEAN DEFAULT FALSE,
  last_active TIMESTAMPTZ DEFAULT NOW(),

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Bật RLS cho bảo mật
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 2. Bảng lưu trữ hành động quẹt (Swipes)
CREATE TABLE public.swipes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  swiper_id VARCHAR(128) REFERENCES public.profiles(id) ON DELETE CASCADE,
  swiped_id VARCHAR(128) REFERENCES public.profiles(id) ON DELETE CASCADE,
  is_like BOOLEAN NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  -- Đảm bảo 1 user chỉ quẹt 1 user khác 1 lần
  UNIQUE(swiper_id, swiped_id)
);

ALTER TABLE public.swipes ENABLE ROW LEVEL SECURITY;

-- 3. Bảng lưu trữ những người dùng đã kết đôi (Matches)
CREATE TABLE public.matches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user1_id VARCHAR(128) REFERENCES public.profiles(id) ON DELETE CASCADE,
  user2_id VARCHAR(128) REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  -- Đảm bảo user1_id luôn nhỏ hơn user2_id để tránh records bị đảo ngược hai chiều
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

-- 4. [NEW] Bảng lưu trữ tính năng Reels / Ngắn (Short Videos)
CREATE TABLE public.reels (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id VARCHAR(128) REFERENCES public.profiles(id) ON DELETE CASCADE,
  video_url TEXT NOT NULL,
  description TEXT,
  likes_count INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.reels ENABLE ROW LEVEL SECURITY;

-- 5. [NEW] Bảng lưu trữ Like cho Reel
CREATE TABLE public.reel_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reel_id UUID REFERENCES public.reels(id) ON DELETE CASCADE,
  user_id VARCHAR(128) REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(reel_id, user_id)
);

ALTER TABLE public.reel_likes ENABLE ROW LEVEL SECURITY;

-- Bật Realtime trên db để có thể track vị trí
ALTER PUBLICATION supabase_realtime ADD TABLE public.profiles;
