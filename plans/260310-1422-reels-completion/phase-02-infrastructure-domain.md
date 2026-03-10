# Phase 02: Infrastructure & Domain
Status: ✅ Complete
Dependencies: Phase 01

## Objective
Di chuyển việc lưu trữ Reels sang Cloudinary trong Infrastructure layer và bổ sung interface/usecases cho Like/Comment trong Domain layer.

## Requirements
### Functional
- [ ] `ReelsDatasource` sử dụng `ImageUploadService` để upload video & thumbnail.
- [ ] Bổ sung usecases: `LikeReel`, `UnlikeReel`, `GetComments`, `PostComment`.

## Implementation Steps
1. [ ] Sửa `reels_datasource.dart`: Thay logic upload Supabase bằng Cloudinary.
2. [ ] Thêm các hàm CRUD cho `reel_likes` và `reel_comments` trong datasource.
3. [ ] Cập nhật `ReelsRepository` interface và implementation.

## Files to Create/Modify
- `lib/features/home/infrastructure/datasources/reels_datasource.dart`
- `lib/features/home/domain/repositories/reels_repository.dart`
- `lib/features/home/infrastructure/repositories/reels_repository_impl.dart`
- `lib/features/home/domain/usecases/reels_usecases.dart` (Thêm các class mới)

---
Next Phase: [Phase 03: Presentation (Store & UI)](phase-03-presentation.md)
