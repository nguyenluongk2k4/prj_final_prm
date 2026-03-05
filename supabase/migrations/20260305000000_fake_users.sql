-- Create fake users for Tinder-like swiping feature
-- Note: Requires `users` to NOT have a strict FK on `auth.users`, which was already removed in migration 20260304000001
-- Using DO block to generate UUIDs dynamically and insert them into both users and profiles

DO $$ 
DECLARE 
  u1 UUID := gen_random_uuid();
  u2 UUID := gen_random_uuid();
  u3 UUID := gen_random_uuid();
  u4 UUID := gen_random_uuid();
  u5 UUID := gen_random_uuid();
  u6 UUID := gen_random_uuid();
  u7 UUID := gen_random_uuid();
  u8 UUID := gen_random_uuid();
  u9 UUID := gen_random_uuid();
  u10 UUID := gen_random_uuid();
BEGIN

-- ======== Insert into public.users ========
INSERT INTO public.users (id, email, name, phone, avatar_url) VALUES 
  (u1, 'jessica@example.com', 'Jessica Parker', '1234567890', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400&h=600&fit=crop'),
  (u2, 'camila@example.com', 'Camila Snow', '1234567891', 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&h=600&fit=crop'),
  (u3, 'bred@example.com', 'Bred Jackson', '1234567892', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&h=600&fit=crop'),
  (u4, 'emma@example.com', 'Emma Wilson', '1234567893', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=600&fit=crop'),
  (u5, 'sophia@example.com', 'Sophia Martinez', '1234567894', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400&h=600&fit=crop'),
  (u6, 'james@example.com', 'James Anderson', '1234567895', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=600&fit=crop'),
  (u7, 'olivia@example.com', 'Olivia Taylor', '1234567896', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=600&fit=crop'),
  (u8, 'william@example.com', 'William Thomas', '1234567897', 'https://images.unsplash.com/photo-1488161628813-04466f872442?w=400&h=600&fit=crop'),
  (u9, 'isabella@example.com', 'Isabella White', '1234567898', 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400&h=600&fit=crop'),
  (u10, 'lucas@example.com', 'Lucas Harris', '1234567899', 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400&h=600&fit=crop');

-- ======== Insert into public.profiles ========
-- Note: age is not a field in the profiles table, it uses birth_date. So we calculate a year to subtract roughly.
-- Added fake locations around Hanoi (approx 21.02, 105.83)
INSERT INTO public.profiles (user_id, display_name, bio, gender, target_gender, birth_date, avatar_url, is_online, latitude, longitude, province_id) VALUES 
  (u1, 'Jessica Parker', 'Professional model living my best life.', 'female', 'male', '2001-05-15', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400&h=600&fit=crop', true, 21.0285, 105.8542, 1),
  (u2, 'Camila Snow', 'Marketer by day, foodie by nature.', 'female', 'male', '2001-11-20', 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&h=600&fit=crop', false, 21.0315, 105.8012, 1),
  (u3, 'Bred Jackson', 'Photograph and adventure seeker.', 'male', 'female', '1999-03-10', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&h=600&fit=crop', true, 21.0185, 105.8112, 1),
  (u4, 'Emma Wilson', 'Designer making things pretty.', 'female', 'male', '2000-07-22', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=600&fit=crop', true, 21.0450, 105.8300, 1),
  (u5, 'Sophia Martinez', 'Artist and coffee addict.', 'female', 'male', '2002-01-30', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400&h=600&fit=crop', false, 21.0020, 105.8400, 1),
  (u6, 'James Anderson', 'Software engineer. I speak mostly in code.', 'male', 'female', '1995-12-05', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=600&fit=crop', true, 21.0150, 105.7800, 1),
  (u7, 'Olivia Taylor', 'Gym rat. Looking for a workout partner.', 'female', 'male', '1998-08-14', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=600&fit=crop', true, 21.0550, 105.8200, 1),
  (u8, 'William Thomas', 'Music producer. Send me your favorite playlist.', 'male', 'female', '1996-04-18', 'https://images.unsplash.com/photo-1488161628813-04466f872442?w=400&h=600&fit=crop', false, 21.0250, 105.8450, 1),
  (u9, 'Isabella White', 'Dog mom. Swipe right if you love golden retrievers.', 'female', 'male', '2000-09-09', 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400&h=600&fit=crop', true, 21.0350, 105.8150, 1),
  (u10, 'Lucas Harris', 'Traveler. Tell me your best trip story.', 'male', 'female', '1997-10-31', 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400&h=600&fit=crop', true, 21.0050, 105.8550, 1);

END $$;
