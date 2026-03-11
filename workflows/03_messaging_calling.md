---
description: Phase 3 - Messaging and Calling (Agora)
---
# Phase 3: Messaging & Video Call (Agora)

**Mục tiêu**: Cung cấp giao diện và chức năng gọi voice/video giữa các người dùng sau khi đã Match, dùng Agora SDK và UI custom theo app.

## 🤖 Copilot (Frontend / UI / MCP)
- **UI/UX**: 
  - Navigation theo kiểu Messenger: mở call dạng full-screen route từ màn hình chat (stack), đóng call quay lại chat.
  - Thiết kế 2 màn hình call theo mock: Incoming Call và In-Call (voice/video).
  - Các nút chính đặt vùng thumb zone: nhận/từ chối, mic, speaker, camera, end.
  - Thêm nhãn trợ năng (accessibility label) cho nút hành động quan trọng.

- **Agora SDK**:
  - Tích hợp Agora (voice/video) cho Android trước, ưu tiên custom UI.
  - Quản lý state call: idle -> ringing -> in_call -> ended.
  - Xử lý quyền mic/camera, background/foreground, mất mạng, timeout.

## 👽 Antigravity (Backend / Core Logic / Supabase SDK)
- **Infrastructure/Supabase**:
  - Sinh Agora token server-side (Edge Function) để không lộ App Certificate.
  - Đồng bộ logic ID: Supabase `id` của user map sang `user_id` trong call payload.
  - Xử lý xác thực: Client chỉ được tạo phòng hoặc gọi điện nếu user gọi và người nghe thực sự là 1 cặp (Kiểm tra trong bảng `matches`).
  - Gửi push khi có incoming call (khi app background) nếu cần.
