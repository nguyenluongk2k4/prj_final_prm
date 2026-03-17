# 📍 Map Module Analysis - Mapbox Integration Status

## 🎯 Project Overview
App hẹn hò kiểu **Tinder + Zenly** với các tính năng:
- ✅ Quẹt thẻ tìm bạn (Card Swiper)
- ✅ Match & Chat (Tencent Cloud Chat SDK)
- ✅ Voice/Video Call (Agora RTC)
- ✅ Reels & Album
- ✅ **Mapbox Location Sharing** (Zenly-like)
- ✅ Gift Sending

---

## 📦 Module Map - Cấu Trúc DDD

### 1. **Domain Layer** (`lib/features/map/domain/`)

#### Entities:
```
├── location_entity.dart          # Vị trí cơ bản (lat, lng, timestamp)
├── tracked_user_entity.dart      # User đang được track (location + heading)
├── map_profile_entity.dart       # Profile info (name, avatar, online status)
├── map_realtime_context.dart     # Context khởi tạo realtime (friends + matches)
├── match_info_entity.dart        # Match info (matchIds, userIds)
└── map_relation.dart             # Enum: self, friend, match
```

#### Repositories (Interfaces):
```
├── i_map_repository.dart         # Location updates & match locations
└── i_map_social_repository.dart  # Friend/match data
```

#### Use Cases:
```
├── get_current_location.dart     # Lấy vị trí hiện tại
├── update_location.dart          # Upload vị trí lên server
├── get_nearby_users.dart         # Tìm users gần đó
├── get_match_locations.dart      # Lấy vị trí match
├── update_match_location.dart    # Upload vị trí match
├── stream_user_locations.dart    # Stream vị trí friends realtime
├── stream_match_locations.dart   # Stream vị trí matches realtime
├── get_friend_ids.dart           # Lấy danh sách friend IDs
├── get_match_info.dart           # Lấy match info
├── get_map_profiles.dart         # Lấy profiles của users
└── stream_match_locations.dart   # Stream match locations
```

### 2. **Infrastructure Layer** (`lib/features/map/infrastructure/`)

#### Data Sources:
```
├── map_remote_data_source.dart
│   ├── updateLocation()          # Upsert vào user_locations table
│   ├── updateMatchLocation()     # Upsert vào match_locations table
│   ├── getCurrentLocation()      # Geolocator.getCurrentPosition()
│   ├── getNearbyUsers()          # Placeholder (cần RPC function)
│   └── getMatchLocations()       # Stream từ match_locations table
│
└── map_social_remote_data_source.dart
    ├── getFriendIds()
    ├── getMatchInfo()
    └── getMapProfiles()
```

#### Models:
```
└── location_model.dart           # LocationModel (Freezed + JSON serializable)
```

#### Repositories (Implementation):
```
├── map_repository_impl.dart      # Implements IMapRepository
└── map_social_repository_impl.dart # Implements IMapSocialRepository
```

### 3. **Presentation Layer** (`lib/features/map/presentation/`)

#### Pages:
```
└── map_page.dart                 # Main map UI (MapWidget + Mapbox)
```

#### Stores (MobX):
```
└── map_store.dart                # State management
    ├── @observable currentLocation
    ├── @observable matchLocations
    ├── @observable nearbyUsers
    ├── @observable isLoading
    ├── @observable errorMessage
    └── @action methods (fetch, update, subscribe)
```

#### Widgets:
```
├── map_debug_panel.dart          # Debug info (token kind, map ready, etc.)
├── map_loading_pill.dart         # Loading indicator
├── map_status_banner.dart        # Error/status messages
└── map_unsupported_platform_view.dart # Fallback for unsupported platforms
```

---

## 🗺️ Mapbox Integration Status

### ✅ **Đã Cấu Hình**

| Item | Status | Details |
|------|--------|---------|
| **Package** | ✅ | `mapbox_maps_flutter: ^2.19.1` |
| **Access Token** | ✅ | `MAPBOX_ACCESS_TOKEN=pk.eyJ1IjoibHVvbmduZ3V5ZW5rMms0IiwiYSI6ImNtbWxxcWljZTI3aTYyb3M2d3hqb2hlNjQifQ.UGmRthbPz--K4cGtBzDG4w` |
| **Style ID** | ✅ | `mapbox/streets-v12` |
| **Map Widget** | ✅ | `MapWidget` được render trong `map_page.dart` |
| **Annotations** | ✅ | `PointAnnotationManager` cho markers |
| **Camera Control** | ✅ | `easeTo()` animation |
| **Location Tracking** | ✅ | `geolocator` + `Geolocator.getPositionStream()` |

### 🔄 **Realtime Features**

| Feature | Status | Implementation |
|---------|--------|-----------------|
| **Friend Locations** | ✅ | `watchUserLocations()` stream từ Supabase |
| **Match Locations** | ✅ | `watchMatchLocations()` stream từ Supabase |
| **Location Upload** | ✅ | Throttled (3s, 5m distance) |
| **Trail Tracking** | ✅ | Lưu 25 điểm gần nhất, tính heading |
| **Heading Calculation** | ✅ | Từ trail points (bearing) |
| **Online Status** | ✅ | Từ profile data |

### ⚠️ **Cần Cải Thiện**

| Issue | Priority | Notes |
|-------|----------|-------|
| **getNearbyUsers()** | 🔴 High | Placeholder - cần RPC function Supabase |
| **Trail Visualization** | 🟡 Medium | Chỉ lưu points, chưa vẽ polyline |
| **Heading Visualization** | 🟡 Medium | Tính toán nhưng chưa hiển thị (rotation icon) |
| **Marker Customization** | 🟡 Medium | Chỉ text + icon size, cần avatar images |
| **Offline Support** | 🟡 Medium | Chưa có caching |
| **Performance** | 🟡 Medium | Có thể optimize annotation updates |

---

## 🔌 Supabase Tables Required

```sql
-- User locations (realtime)
CREATE TABLE user_locations (
  user_id UUID PRIMARY KEY,
  latitude FLOAT NOT NULL,
  longitude FLOAT NOT NULL,
  timestamp TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY (user_id) REFERENCES profiles(user_id)
);

-- Match locations (realtime)
CREATE TABLE match_locations (
  user_id UUID NOT NULL,
  match_id UUID NOT NULL,
  latitude FLOAT NOT NULL,
  longitude FLOAT NOT NULL,
  timestamp TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (user_id, match_id),
  FOREIGN KEY (user_id) REFERENCES profiles(user_id)
);

-- Realtime subscriptions
ALTER TABLE user_locations REPLICA IDENTITY FULL;
ALTER TABLE match_locations REPLICA IDENTITY FULL;
```

---

## 🎮 Map Page Flow

```
MapPage (StatefulWidget)
  ↓
initState()
  ├─ _initRealtime()
  │  ├─ loadRealtimeContext(userId)
  │  │  ├─ getFriendIds()
  │  │  ├─ getMatchInfo()
  │  │  ├─ getMapProfiles()
  │  │  └─ _applyProfiles()
  │  ├─ _subscribeToUserLocations()
  │  └─ _subscribeToMatchLocations()
  ↓
_onMapReady(MapboxMap)
  ├─ _createAnnotationManagers()
  ├─ _startLocationTracking()
  └─ _centerOnUser()
  ↓
Location Updates (Realtime)
  ├─ _handleUserLocations()
  ├─ _handleMatchLocations()
  ├─ _updateTrackedUserLocations()
  ├─ _appendTrail()
  └─ _updateAnnotations()
```

---

## 📊 Data Flow

```
Geolocator.getPositionStream()
  ↓
_mapStore.currentLocation (LatLng)
  ↓
_handleMyLocation()
  ├─ _appendMyTrail()
  ├─ _maybeUploadLocation() → updateLocation() → Supabase
  └─ _animateCamera()

Supabase Realtime (user_locations)
  ↓
_mapStore.watchUserLocations()
  ↓
_handleUserLocations()
  ├─ _updateTrackedUserLocations()
  ├─ _appendTrail()
  └─ _updateAnnotations() → PointAnnotationManager
```

---

## 🎨 Marker System

### Current Implementation:
```dart
PointAnnotationOptions(
  geometry: Point(coordinates: Position(lng, lat)),
  textField: displayName,
  textOffset: [0.0, 2.0],
  textSize: 12.0,
  textAnchor: TextAnchor.TOP,
  iconAnchor: IconAnchor.BOTTOM,
  iconSize: 0.15,  // Friends
  // or
  iconSize: 0.2,   // Current user
)
```

### Improvements Needed:
- [ ] Avatar images thay vì text
- [ ] Color coding (friend vs match)
- [ ] Online status indicator
- [ ] Heading arrow/rotation
- [ ] Trail polylines

---

## 🔐 Environment Variables

```env
# Mapbox
MAPBOX_ACCESS_TOKEN=pk.eyJ1IjoibHVvbmduZ3V5ZW5rMms0IiwiYSI6ImNtbWxxcWljZTI3aTYyb3M2d3hqb2hlNjQifQ.UGmRthbPz--K4cGtBzDG4w
MAPBOX_STYLE_ID=mapbox/streets-v12
# MAPBOX_SECRET_TOKEN=YOUR_MAPBOX_SECRET_DOWNLOAD_TOKEN (optional)
```

---

## 🚀 Key Features Working

✅ **Real-time Location Sharing**
- Friends' locations update realtime từ Supabase
- Match locations tracked separately
- Current user location auto-upload (throttled)

✅ **Trail Tracking**
- Lưu 25 điểm gần nhất per user
- Tính heading từ movement direction
- Distance filter (8m minimum)

✅ **Camera Control**
- Auto-center on user location
- Smooth animation (450ms)
- Follow mode toggle

✅ **Permissions**
- Location permission request
- Graceful fallback if denied

✅ **Error Handling**
- Status banner for errors
- Debug panel (debug mode)
- Fallback UI for unsupported platforms

---

## 🐛 Known Issues & TODOs

### High Priority:
1. **getNearbyUsers()** - Currently placeholder, needs Supabase RPC
2. **Avatar Markers** - Replace text with actual user avatars
3. **Trail Visualization** - Draw polylines for movement history

### Medium Priority:
1. **Heading Visualization** - Show direction arrow on markers
2. **Performance** - Optimize annotation updates for 50+ users
3. **Offline Support** - Cache last known locations

### Low Priority:
1. **Clustering** - Group markers when zoomed out
2. **Heatmap** - Show popular areas
3. **Geofencing** - Notify when friends enter/leave areas

---

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| **Android** | ✅ | Fully supported |
| **iOS** | ✅ | Fully supported |
| **Web** | ❌ | Not supported (kIsWeb check) |
| **Windows/Mac** | ❌ | Not supported |

---

## 🔗 Related Features

- **Chat Module** - Tencent Cloud Chat SDK
- **Call Module** - Agora RTC (voice/video)
- **Auth Module** - User authentication & presence
- **Profile Module** - User profile data
- **Album Module** - Photo sharing

---

## 📝 Summary

**Map Module Status: 🟢 FUNCTIONAL**

Mapbox integration đã hoạt động tốt với:
- ✅ Real-time location tracking
- ✅ Friend & match location display
- ✅ Trail history
- ✅ Heading calculation
- ✅ Smooth camera animations

**Cần cải thiện:**
- 🟡 Marker visualization (avatars, colors)
- 🟡 Trail polylines
- 🟡 getNearbyUsers() implementation
- 🟡 Performance optimization

**Mapbox Token:** Valid & Active ✅
