---
description: Phase 1 - Authentication and Profile Management
---
# Phase 1: Authentication & Profile (Firebase + Supabase)

**Mục tiêu**: Người dùng có thể đăng ký/đăng nhập qua Firebase (SĐT, Email, Social). Sau khi đăng nhập, profile sẽ được đồng bộ lên Supabase. Áp dụng song ngữ và Dark/Light mode cho toàn bộ luồng.

## 🤖 Copilot (Frontend / UI / MCP)
- **UI/UX**: 
  - Xây dựng màn hình Onboarding, Login, Register, và Create Profile.
  - Tích hợp thay đổi Theme (Dark/Light mode) dựa trên cấu trúc DDD (`core/theme`).
  - Tích hợp đa ngôn ngữ (Bilingual) thông qua `easy_localization` hoặc `flutter_localizations`.
- **Data/Domain**:
  - Khai báo các Entity, Model, UseCase cho quá trình Authentication.
- **Tương tác**: Sử dụng các Repository interface mà Antigravity cung cấp. Cung cấp file thiết kế Widget, Bloc để backend nắm và map đúng dữ liệu.

## 👽 Antigravity (Backend / Core Logic / Supabase SDK)
- **Infrastructure**:
  - Viết logic thực tế kết nối Firebase SDK để lấy thông tin Auth (UID, Token).
  - Viết `UserRepositoryImpl` và `AuthRepositoryImpl` gọi API/SDK của Supabase để kiểm tra và cập nhật thông tin trong bảng `profiles`.
- **Database/Supabase**:
  - Đảm bảo database mapping an toàn: Firebase UID đóng vai trò là Primary Key (kiểu VARCHAR) trên bảng `profiles`.
  - Thiết lập RLS (Row Level Security) cho phép user chỉ được xem/sửa thông tin profile của họ.
