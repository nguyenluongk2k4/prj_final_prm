# Phase 01: Core Service Enhancement
Status: ✅ Complete
Dependencies: None

## Objective
Nâng cấp `ImageUploadService` để hỗ trợ upload video lên Cloudinary với các tham số tối ưu hóa cho streaming.

## Requirements
### Functional
- [ ] Hỗ trợ upload video (mp4, mov, etc.) lên Cloudinary.
- [ ] Tự động gán tag hoặc folder `reels` để dễ quản lý.
- [ ] Trả về URL video đã được tối ưu hóa (f_auto, q_auto).

## Implementation Steps
1. [ ] Cập nhật `ImageUploadService.dart` thêm phương thức `uploadVideo`.
2. [ ] Xử lý `resource_type: 'video'` trong request gửi tới Cloudinary.
3. [ ] Kiểm tra việc nhận link `secure_url`.

## Files to Create/Modify
- `lib/core/services/image_upload_service.dart` - Thêm logic upload video.

## Test Criteria
- [ ] Test upload 1 video mẫu (qua unit test hoặc script tạm).
- [ ] Kiểm tra URL trả về có chạy được trên trình duyệt/player không.

---
Next Phase: [Phase 02: Infrastructure & Domain](phase-02-infrastructure-domain.md)
