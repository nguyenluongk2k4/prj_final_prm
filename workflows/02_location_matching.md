---
description: Phase 2 - Location and Matching Mechanics
---
# Phase 2: Location, Swiping & Core Matching

**Mục tiêu**: Lọc và hiển thị các đối tượng xung quanh dựa trên vị trí (Mapbox + PostGIS). Xử lý luồng quẹt (Swipe) kiểu Tinder và tạo Match khi 2 bên cùng thích nhau.

## 🤖 Copilot (Frontend / UI / MCP)
- **UI/UX**: 
  - Tích hợp Mapbox widget bằng SDK (hiển thị vị trí). Gửi Location lên UI Layer.
  - Xây dựng Tinder-like Swipe Cards (Animation Quẹt trái/phải, Nút Dislike/Like/SuperLike).
  - Áp dụng xuyên suốt Dark/Light mode và đa ngôn ngữ cho thẻ thông tin.
- **Data/Domain**:
  - Viết UseCase thao tác nghiệp vụ: `GetNearbyUsersUseCase`, `SwipeUserUseCase`.

## 👽 Antigravity (Backend / Core Logic / Supabase SDK)
- **Database/Supabase**:
  - Thiết kế Store Procedure hoặc RPC với PostGIS extension trên Supabase để truy vấn user theo khoảng cách không gian (Spatial Queries - e.g. `ST_DWithin`).
  - Lưu Record quẹt vào bảng `swipes`. Tính toán nếu User A Swipe Right B và User B Swipe Right A thì sẽ tạo 1 dòng mới trong bảng `matches`.
- **Infrastructure**:
  - Viết code gọi tới RPC Supabase để fetch danh sách profile xung quanh (Pagination, Filters).
  - Kết nối dữ liệu vào `NearbyUsersRepositoryImpl` đưa lên kết quả cho UseCase phía Copilot gọi.
