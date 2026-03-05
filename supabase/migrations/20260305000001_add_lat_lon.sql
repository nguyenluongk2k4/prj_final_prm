-- Thay đổi cột location từ geography(POINT) phức tạp sang latitude và longitude dễ quản lý từ Flutter
-- Điều này cho phép app dễ dàng đọc và cập nhật tọa độ (double) thay vì dùng query PostGIS phức tạp

ALTER TABLE public.profiles
DROP COLUMN IF EXISTS location;

ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS latitude DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS province_id INT REFERENCES public.provinces(id);
