# Mapbox Setup Guide

## Vấn đề đã fix ✅

### Android
1. ✅ Đã tạo file `android/app/src/main/res/values/strings.xml` với Mapbox token
2. ✅ Đã thêm Mapbox Maven repository vào `android/settings.gradle.kts`
3. ✅ Đã thêm `MAPBOX_DOWNLOADS_TOKEN` vào `android/gradle.properties`

### Flutter Code
1. ✅ Đã thêm debug logging vào `map_page.dart` để dễ troubleshoot
2. ✅ Token đã có sẵn trong `.env`

## iOS Setup (Manual - Làm thủ công)

### Bước 1: Tạo file `.netrc`
Trên macOS/Linux, tạo file `~/.netrc` với nội dung:

```
machine api.mapbox.com
login mapbox
password sk.eyJ1IjoibHVvbmduZ3V5ZW5rMms0IiwiYSI6ImNtbWxxcWljZTI3aTYyb3M2d3hqb2hlNjQifQ.UGmRthbPz--K4cGtBzDG4w
```

**Commands:**
```bash
# Tạo file .netrc
cat >> ~/.netrc <<EOF
machine api.mapbox.com
login mapbox
password sk.eyJ1IjoibHVvbmduZ3V5ZW5rMms0IiwiYSI6ImNtbWxxcWljZTI3aTYyb3M2d3hqb2hlNjQifQ.UGmRthbPz--K4cGtBzDG4w
EOF

# Set permissions (bắt buộc!)
chmod 600 ~/.netrc
```

### Bước 2: Clean và rebuild
```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Rebuild
flutter run
```

## Debugging

### Kiểm tra console logs
Khi chạy app, mở Flutter DevTools hoặc xem console để thấy logs:
```
[MapPage] Configuring Mapbox access token...
[MapPage] Token found: pk.eyJ1Ijoi...
[MapPage] Mapbox access token configured successfully
[MapPage] Map created!
[MapPage] Map loaded!
[MapPage] Map style loaded!
```

### Nếu map vẫn trắng
1. Kiểm tra logs xem có lỗi gì không
2. Verify token còn hạn tại https://account.mapbox.com/
3. Thử run trên physical device thay vì emulator
4. Kiểm tra location permissions

### Test location permission
```bash
# Android: Reset permissions
adb shell pm reset-com.example.prj_final_prm
```

## Token Information

- **Public Token (pk.)**: Dùng để hiển thị map - ✅ Đã có trong `.env`
- **Secret Token (sk.)**: Dùng để download SDK - ✅ Đã thêm vào `gradle.properties`

**Lưu ý**: Secret token trong `gradle.properties` chỉ dùng cho build system, không commit lên Git.

## Troubleshooting

### Lỗi: "Map load error: Failed to load style"
- Token không đúng hoặc hết hạn
- Kiểm tra internet connection
- Verify token tại https://account.mapbox.com/

### Lỗi: "Location permission denied"
- Vào Settings > Apps > Heart Link > Permissions > Location
- Chọn "Allow only while using the app"

### Lỗi Android build: "Could not resolve mapbox"
- Check `gradle.properties` có `MAPBOX_DOWNLOADS_TOKEN`
- Token phải bắt đầu bằng `sk.`
- Thử `flutter clean && flutter pub get`

### iOS build lỗi
- Check `~/.netrc` tồn tại và có permissions `600`
- Format file phải chính xác (không thừa space)
- Xcode > Product > Clean Build Folder

## Next Steps

1. **Android**: Run `flutter run` và check logs
2. **iOS**: Tạo file `~/.netrc` trước, sau đó run `flutter run`
3. Test location feature bằng cách click floating action button

## Files đã thay đổi

```
✅ android/app/src/main/res/values/strings.xml (mới)
✅ android/settings.gradle.kts (thêm Mapbox repo)
✅ android/gradle.properties (thêm MAPBOX_DOWNLOADS_TOKEN)
✅ lib/features/map/presentation/pages/map_page.dart (thêm debug logs)
✅ .netrc.example (template cho iOS)
```
