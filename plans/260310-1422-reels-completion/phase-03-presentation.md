# Phase 03: Presentation (Store & UI)
Status: ✅ Complete
Dependencies: Phase 02

## Objective
Triển khai logic MobX store và hoàn thiện giao diện người dùng cho Reels.

## Requirements
### Functional
- [ ] `ReelsStore` xử lý `toggleLike` mượt mà (optimistic update).
- [ ] Hiển thị danh sách comment trong Bottom Sheet.
- [ ] Cho phép người dùng đăng comment mới.

## Implementation Steps
1. [ ] Hoàn thiện `toggleLike` trong `reels_store.dart`.
2. [ ] Thêm `comments` observable và `fetchComments` action trong store.
3. [ ] Build `CommentsBottomSheet` widget.
4. [ ] Cập nhật `ReelCard` để tích hợp các tính năng mới.

## Files to Create/Modify
- `lib/features/home/presentation/stores/reels_store.dart`
- `lib/features/home/presentation/widgets/reel_card.dart`
- `lib/features/home/presentation/widgets/comments_bottom_sheet.dart` [NEW]

---
Next Phase: [Phase 04: Integration & Testing](phase-04-integration-testing.md)
