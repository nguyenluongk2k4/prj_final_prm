---
description: Phase 5 - Maps for friends (Pump-like Realtime Map Tracking)
---
# Phase 5: Map cho Bạn Bè (Thống kê & Real-time Location)

**Mục tiêu**: Người dùng bấm vào tính năng Bản đồ (Map) và thấy được Avatar của những **người bạn (đã Match)** nhảy trên bản đồ thời gian thực (Giống ứng dụng Zenly / Pump).

## 🤖 Copilot (Frontend / UI / MCP)
- **UI/UX**: 
  - Kế thừa giao diện Mapbox từ Phase 2, chỉnh sửa để thay vì quét người lạ, map này sẽ show **bạn bè**.
  - Xử lý Custom Marker Map: Render Avatar của bạn bè trên bản đồ ở tọa độ tương ứng (Custom Painter/Markers).
  - Áp dụng UI (Dark/Light Mode) cho Popup thông tin khi click vào Avatar.
  - Áp dụng đa ngôn ngữ hiển thị Text như "Vừa truy cập", "Cách đây 5 phút", "Trong thành phố lớn"...
- **Data/Domain**:
  - Subscription dữ liệu Realtime. Cập nhật Marker khi vị trí thay đổi (nhưng cần tối ưu để không render giật lag).

## 👽 Antigravity (Backend / Core Logic / Supabase SDK)
- **Supabase Realtime**:
  - Dùng **Supabase Realtime** channel để lắng nghe (subscribe) các Profile của những người *đã match*. (Chỉ chia sẻ location cho bạn bè).
  - Gửi / Nhận broadcast: Khi user đang bật app di chuyển, ứng dụng bắn broadcast Realtime toạ độ mới lên cho bạn bè, hoặc update lên DB rồi listen DB update.
- **Database Architecture**:
  - Bảng `profiles` cần có cờ cập nhật (`is_online`, `last_active_location`). Dùng RLS để chỉ **bạn bè** mới đọc được thông tin Real-time Location của nhau.
  - Tối ưu RPC, tránh cập nhật liên tục làm tốn Data Transfer (e.g. Rate-limit 5s 1 lần cập nhật). Cài đặt các Channel phù hợp.
