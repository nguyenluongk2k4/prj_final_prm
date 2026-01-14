# Flutter Gen - Assets Generator

Flutter Gen tự động generate code cho assets (images, icons, fonts, colors).

## Usage

### 1. Generate assets code
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. Sử dụng trong code
```dart
// Images
Image.asset(Assets.images.logo.path)

// Icons
Image.asset(Assets.icons.home.path)

// Colors (from colors.xml)
Color primary = ColorName.primary;
```

## Thêm assets mới

1. Thêm file vào folder `assets/images/` hoặc `assets/icons/`
2. Chạy: `dart run build_runner build --delete-conflicting-outputs`
3. Dùng: `Assets.images.yourImage.path`

## Folder structure
```
assets/
  ├── images/     # Hình ảnh
  ├── icons/      # Icons
  └── colors/     # Colors XML
```
