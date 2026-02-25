# Hướng Dẫn Setup Các Dịch Vụ Core (Supabase, Firebase, Mapbox, Tencent)

Dự án sử dụng file `.env` để bảo mật thông tin. Hãy copy file `.env.example` (nếu có) thành `.env` và điền các khóa API vào.

## 1. Supabase
Supabase được sử dụng làm Database chính (PostgreSQL) và Realtime tracking.
1. Truy cập [Supabase Dashboard](https://app.supabase.com/).
2. Tạo Project mới (hoặc dùng project hiện tại).
3. Vào **Project Settings** -> **API**, copy `Project URL` và `anon public key` dán vào file `.env`:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
4. Chạy file SQL Script trong thư mục `supabase/migrations/20260225000000_init_schema.sql` vào Supabase SQL Editor để khởi tạo database.

## 2. Firebase (Authentication)
Firebase dùng thao tác đăng nhập bằng SĐT, Email, Google, Facebook...
1. Truy cập [Firebase Console](https://console.firebase.google.com/).
2. Tạo dự án mới. Lấy các chứng chỉ dán vào `.env` (Nếu dùng `flutterfire_cli` thì bỏ qua việc nhập .env thủ công).
3. Cài đặt Firebase CLI và chạy:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
4. Bật Authentication (Email/Password, Phone, Google) trong Firebase Console.

## 3. Mapbox (Vị trí & Bản đồ)
1. Tạo tài khoản tại [Mapbox](https://www.mapbox.com/).
2. Tạo một **Public Token** để hiển thị bản đồ ở phía Client, dán vào `MAPBOX_ACCESS_TOKEN` ở `.env`.
3. Tạo một **Secret Token** (có quyền `Downloads:Read`) để có thể tải SDK Mapbox.
4. Setup SDK cho Android/iOS (bạn phải dán thẻ `<string name="mapbox_access_token">` trong string.xml Android và `.netrc` theo tài liệu Mapbox).

## 4. Tencent Kit (TUI Chat / Call)
1. Đăng ký tài khoản ở [Tencent Cloud](https://intl.cloud.tencent.com/).
2. Tìm kiếm **IM (Instant Messaging)** và tạo ứng dụng mới.
3. Lấy `SDKAppID` và `SecretKey` từ Console, dán vào:
   - `TENCENT_SDK_APP_ID`
   - `TENCENT_SECRET_KEY`
4. Cấu hình module TUI Chat và Call theo Doc của Tencent (iOS cần cấu hình Info.plist Microphone/Camera permissions, Android cấu hình MinSDK 21).

## 5. Tải Thư Viện
Mở terminal và chạy lệnh:
```bash
flutter pub get
```
Và sau đó chạy code generation (nếu cần):
```bash
dart run build_runner build -d
```
