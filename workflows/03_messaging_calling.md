---
description: Phase 3 - Messaging and Calling (Tencent Kit)
---
# Phase 3: Messaging & Video Call (Tencent Kit / TUI)

**Mục tiêu**: Cung cấp giao diện và chức năng trao đổi giữa các người dùng sau khi đã Match thông qua hệ sinh thái của Tencent Kit.

## 🤖 Copilot (Frontend / UI / MCP)
- **UI/UX**: 
  - Import và cấu hình bộ UI của Tencent (`tencent_cloud_chat_sdk`, `tencent_calls_uikit`).
  - Tùy chỉnh (Customize) UI của TUI Chat và TUI Call sao cho đồng bộ với App Theme (Dark/Light).
  - Khai báo file ngôn ngữ của Tencent Kit cho khớp với i18n của app.
  - Hiển thị danh sách Match ngang phía trên (Tinder Style), danh sách tin nhắn mới bên dưới. Bấm vào ai thì chuyển hướng mở phòng chat.

## 👽 Antigravity (Backend / Core Logic / Supabase SDK)
- **Infrastructure/Supabase**:
  - Phát sinh bảo mật `UserSig` cho kết nối tới Tencent Cloud (Cần 1 Edge Function hoặc code server-side để ký HMAC-SHA256 bí mật không bị lộ ở client). Backend gọi API để lấy UserSig trả cho TUI đăng nhập.
  - Đồng bộ logic ID: Supabase `id` của user sẽ tương đương với `userID` trong hệ thống Tencent IM.
  - Cấu hình Notification (Push Message) thông qua sự kiện webhooks của Tencent sang thiết bị.
  - Xử lý xác thực: Client chỉ được tạo phòng hoặc gọi điện nếu user gọi và người nghe thực sự là 1 cặp (Kiểm tra trong bảng `matches`).
