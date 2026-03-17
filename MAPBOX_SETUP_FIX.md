# 🗺️ Mapbox Maps Flutter - Setup Fix Guide

## Current Status ✅

Anh đã cấu hình khá tốt rồi:

### Android ✅
- Mapbox Access Token trong `AndroidManifest.xml`
- Location permissions khai báo
- Telemetry disabled

### iOS ✅
- Location permissions trong `Info.plist`
- Background modes configured

---

## Issue: App không hiện map

### Nguyên nhân có thể:

1. **MapboxOptions.setAccessToken() chưa được gọi** - Cần set token trong code
2. **Mapbox token không được load từ .env** - Token cần được pass vào app
3. **Map widget chưa được initialize đúng** - Cần MapboxOptions setup
4. **Platform không support** - Web/Desktop không support

---

## Fix Steps

### Step 1: Update main.dart - Set Mapbox Token

Thêm vào `main()` function trước `runApp()`:

```dart
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load Env
  await dotenv.load(fileName: ".env");

  // ✅ SET MAPBOX ACCESS TOKEN - CRITICAL!
  final mapboxToken = dotenv.env['MAPBOX_ACCESS_TOKEN'];
  if (mapboxToken != null && mapboxToken.isNotEmpty) {
    MapboxOptions.setAccessToken(mapboxToken);
  } else {
    debugPrint('❌ MAPBOX_ACCESS_TOKEN not found in .env');
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // ... rest of initialization
}
```

### Step 2: Verify .env has valid token

Check `.env`:
```env
MAPBOX_ACCESS_TOKEN=pk.eyJ1IjoibHVvbmduZ3V5ZW5rMms0IiwiYSI6ImNtbWxxcWljZTI3aTYyb3M2d3hqb2hlNjQifQ.UGmRthbPz--K4cGtBzDG4w
```

✅ Token starts with `pk.` (public token) - Correct!

### Step 3: Update map_page.dart - Simplify MapWidget

Replace the MapWidget creation with simpler version:

```dart
MapWidget(
  key: const ValueKey('mapbox_map'),
  styleUri: 'mapbox://styles/mapbox/streets-v12',
  cameraOptions: CameraOptions(
    center: Point(coordinates: Position(_fallbackLng, _fallbackLat)),
    zoom: 12.5,
  ),
  onMapCreated: _onMapReady,
)
```

### Step 4: Verify Android Manifest

Already configured ✅

```xml
<meta-data
    android:name="com.mapbox.common.accessToken"
    android:value="pk.eyJ1IjoibHVvbmduZ3V5ZW5rMms0IiwiYSI6ImNtbWxxcWljZTI3aTYyb3M2d3hqb2hlNjQifQ.UGmRthbPz--K4cGtBzDG4w" />
```

### Step 5: Verify iOS Info.plist

Already configured ✅

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open so we can find people nearby.</string>
```

### Step 6: Clean & Rebuild

```bash
# Clean
flutter clean
rm -rf build/
rm -rf ios/Pods ios/Podfile.lock

# Get dependencies
fvm flutter pub get

# Rebuild
fvm flutter run
```

---

## Debugging Checklist

### ❌ Map still not showing?

1. **Check token is set:**
   ```dart
   // Add this in map_page.dart initState
   debugPrint('[MapPage] Token: ${dotenv.env['MAPBOX_ACCESS_TOKEN']}');
   ```

2. **Check MapboxMap controller:**
   ```dart
   void _onMapReady(MapboxMap mapboxMap) {
     debugPrint('[MapPage] ✅ Map ready: $mapboxMap');
     _mapboxMap = mapboxMap;
     _mapReady = true;
   }
   ```

3. **Check for errors in logcat/console:**
   ```bash
   # Android
   flutter logs | grep -i mapbox
   
   # iOS
   flutter logs | grep -i mapbox
   ```

4. **Verify platform support:**
   ```dart
   // map_page.dart already has this check
   bool _isSupportedPlatform() {
     if (kIsWeb) return false;  // Web not supported
     return defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS;
   }
   ```

---

## Common Issues & Solutions

### Issue 1: "Mapbox access token not configured"
**Solution:** Call `MapboxOptions.setAccessToken()` in main.dart before runApp()

### Issue 2: "Platform not supported"
**Solution:** Only Android/iOS supported. Web/Desktop will show error message.

### Issue 3: "Map shows but no annotations"
**Solution:** Ensure `_pointAnnotationManager` is created in `_createAnnotationManagers()`

### Issue 4: "Location permission denied"
**Solution:** Request permission in `_startLocationTracking()` using permission_handler

### Issue 5: "Blank white screen"
**Solution:** Check if MapWidget is inside Positioned.fill() or has proper constraints

---

## Minimal Working Example

If map still doesn't show, try this minimal version:

```dart
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  final token = dotenv.env['MAPBOX_ACCESS_TOKEN'];
  if (token != null) {
    MapboxOptions.setAccessToken(token);
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MapWidget(
          styleUri: 'mapbox://styles/mapbox/streets-v12',
          cameraOptions: CameraOptions(
            center: Point(coordinates: Position(105.8542, 21.0285)),
            zoom: 12.0,
          ),
        ),
      ),
    );
  }
}
```

---

## Next Steps

1. ✅ Add `MapboxOptions.setAccessToken()` to main.dart
2. ✅ Verify token in .env
3. ✅ Clean & rebuild
4. ✅ Test on Android/iOS device
5. ✅ Check logs for errors
6. ✅ Add markers/annotations once map shows

---

## Resources

- [Mapbox Maps Flutter Docs](https://docs.mapbox.com/flutter/maps/guides/)
- [GitHub: mapbox-maps-flutter](https://github.com/mapbox/mapbox-maps-flutter)
- [Mapbox Access Tokens](https://docs.mapbox.com/accounts/concepts/tokens/)

---

## Token Info

**Current Token:** `pk.eyJ1IjoibHVvbmduZ3V5ZW5rMms0IiwiYSI6ImNtbWxxcWljZTI3aTYyb3M2d3hqb2hlNjQifQ.UGmRthbPz--K4cGtBzDG4w`

- ✅ Valid public token (starts with `pk.`)
- ✅ Can be used in client-side code
- ✅ No secret token needed for basic map display

---

## Summary

**Main Fix:** Add `MapboxOptions.setAccessToken(token)` in main.dart before runApp()

This is the critical step that initializes Mapbox SDK with your access token!
