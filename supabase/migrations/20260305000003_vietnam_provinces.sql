-- Create provinces table to store 63 provinces/cities of Vietnam
CREATE TABLE public.provinces (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  type TEXT, -- e.g. "Thành phố trung ương", "Tỉnh"
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.provinces ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view provinces"
  ON public.provinces
  FOR SELECT
  USING (true);

-- Insert 63 provinces of Vietnam (Based on standard administrative units)
INSERT INTO public.provinces (name, type) VALUES
('Hà Nội', 'Thành phố Trung ương'),
('Hồ Chí Minh', 'Thành phố Trung ương'),
('Hải Phòng', 'Thành phố Trung ương'),
('Đà Nẵng', 'Thành phố Trung ương'),
('Cần Thơ', 'Thành phố Trung ương'),
('Hà Giang', 'Tỉnh'),
('Cao Bằng', 'Tỉnh'),
('Lai Châu', 'Tỉnh'),
('Lào Cai', 'Tỉnh'),
('Tuyên Quang', 'Tỉnh'),
('Lạng Sơn', 'Tỉnh'),
('Bắc Kạn', 'Tỉnh'),
('Thái Nguyên', 'Tỉnh'),
('Yên Bái', 'Tỉnh'),
('Sơn La', 'Tỉnh'),
('Phú Thọ', 'Tỉnh'),
('Vĩnh Phúc', 'Tỉnh'),
('Quảng Ninh', 'Tỉnh'),
('Bắc Giang', 'Tỉnh'),
('Bắc Ninh', 'Tỉnh'),
('Hải Dương', 'Tỉnh'),
('Hưng Yên', 'Tỉnh'),
('Hòa Bình', 'Tỉnh'),
('Hà Nam', 'Tỉnh'),
('Nam Định', 'Tỉnh'),
('Thái Bình', 'Tỉnh'),
('Ninh Bình', 'Tỉnh'),
('Thanh Hóa', 'Tỉnh'),
('Nghệ An', 'Tỉnh'),
('Hà Tĩnh', 'Tỉnh'),
('Quảng Bình', 'Tỉnh'),
('Quảng Trị', 'Tỉnh'),
('Thừa Thiên Huế', 'Tỉnh'),
('Quảng Nam', 'Tỉnh'),
('Quảng Ngãi', 'Tỉnh'),
('Kon Tum', 'Tỉnh'),
('Gia Lai', 'Tỉnh'),
('Bình Định', 'Tỉnh'),
('Phú Yên', 'Tỉnh'),
('Đắk Lắk', 'Tỉnh'),
('Khánh Hòa', 'Tỉnh'),
('Đắk Nông', 'Tỉnh'),
('Lâm Đồng', 'Tỉnh'),
('Ninh Thuận', 'Tỉnh'),
('Bình Phước', 'Tỉnh'),
('Tây Ninh', 'Tỉnh'),
('Bình Dương', 'Tỉnh'),
('Đồng Nai', 'Tỉnh'),
('Bình Thuận', 'Tỉnh'),
('Bà Rịa - Vũng Tàu', 'Tỉnh'),
('Long An', 'Tỉnh'),
('Đồng Tháp', 'Tỉnh'),
('An Giang', 'Tỉnh'),
('Tiền Giang', 'Tỉnh'),
('Vĩnh Long', 'Tỉnh'),
('Bến Tre', 'Tỉnh'),
('Kiên Giang', 'Tỉnh'),
('Hậu Giang', 'Tỉnh'),
('Trà Vinh', 'Tỉnh'),
('Sóc Trăng', 'Tỉnh'),
('Bạc Liêu', 'Tỉnh'),
('Cà Mau', 'Tỉnh'),
('Điện Biên', 'Tỉnh')
ON CONFLICT (name) DO NOTHING;

-- Optional: Update public.profiles to use a foreign key if you want strict enforcement
-- ALTER TABLE public.profiles ADD COLUMN province_id INT REFERENCES public.provinces(id);
