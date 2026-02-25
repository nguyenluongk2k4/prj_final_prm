---
description: Phase 4 - Reels and Short Video Feeds
---
# Phase 4: Reels & Tương tác (Tiktok/Instagram-like)

**Mục tiêu**: Người dùng có thể xem video ngắn (Reels), thả tim, xem thông tin người đăng, vuốt để chuyển video tiếp theo.

## 🤖 Copilot (Frontend / UI / MCP)
- **UI/UX**: 
  - Tích hợp package video_player hoặc các lib tối ưu cho Flutter (như `media_kit`).
  - Xây dựng layout Full-screen swipe (Pageview dọc) để lướt các Reels.
  - Các nút tương tác: Like, Đi tới Profile.
  - Áp dụng các mảng màu thống nhất theo Theme (Dark/Light).
- **Data/Domain**:
  - Tạo các model, entity cho `Reel`, `Like`.
  - Fetch feed video dạng phân trang (Pagination).

## 👽 Antigravity (Backend / Core Logic / Supabase SDK)
- **Database/Supabase**:
  - Đảm bảo DB có bảng `reels` lưu `video_url`, `description`, `likes_count`.
  - Viết function/RPC hoặc policy để lấy danh sách các Reels mới nhất, ưu tiên video của người có vị trí gần kề hoặc sở thích phù hợp.
- **Infrastructure**:
  - Viết API gọi Firebase Storage lấy video. (nếu User setup upload video trên Firebase, hỗ trợ stream video).
  - Tối ưu Caching ở tầng Data để tránh tải lại cùng 1 video nhiều lần. Lắng nghe `onVideoEnd` để load chunk tiếp theo.
