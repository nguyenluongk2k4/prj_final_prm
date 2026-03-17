
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vibration/vibration.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/stores/auth_store.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/map_profile_entity.dart';
import '../../domain/entities/tracked_user_entity.dart';
import '../../domain/usecases/send_map_gift.dart';
import '../../infrastructure/datasources/map_gift_datasource.dart';
import '../../infrastructure/map_store_factory.dart';
import '../../infrastructure/repositories/map_gift_repository_impl.dart';
import '../stores/map_store.dart';

const _kGifts = ['🎁', '🌹', '💝', '⭐', '🍫', '💌', '🎀', '🎊'];

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  static const double _fallbackLat = 21.0285;
  static const double _fallbackLng = 105.8542;

  final AuthStore _authStore = GetIt.I<AuthStore>();
  late final MapStore _mapStore = MapStoreFactory.create();
  final MapController _mapController = MapController();

  late final SendMapGift _sendMapGift = SendMapGift(
    MapGiftRepositoryImpl(MapGiftDataSource(Supabase.instance.client)),
  );

  ReactionDisposer? _locationDisposer;
  StreamSubscription<geolocator.Position>? _positionSub;
  StreamSubscription<List<LocationEntity>>? _userLocationsSub;
  StreamSubscription<List<LocationEntity>>? _matchLocationsSub;

  final Map<String, TrackedUserEntity> _trackedUsers = {};
  final Map<String, List<LatLng>> _trails = {};

  bool _isLocating = false;
  bool _followUser = true;
  String? _errorMessage;
  String? _currentUserId;

  DateTime? _lastUploadAt;
  LatLng? _lastUploadLocation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Gift throw animation state
  AnimationController? _throwController;
  Animation<Offset>? _throwAnim;
  String? _throwingGift;

  final Set<String> _knownUserIds = {};
  final _distance = const Distance();

  @override
  void initState() {
    super.initState();
    _currentUserId = _authStore.currentUser?.id;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    _locationDisposer = reaction<LatLng?>(
      (_) => _mapStore.currentLocation,
      (location) => _handleMyLocation(location),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initRealtime();
      _startLocationTracking();
    });
  }

  // ---------------------------------------------------------------------------
  // Realtime
  // ---------------------------------------------------------------------------

  Future<void> _initRealtime() async {
    final uid = _currentUserId ?? _authStore.currentUser?.id;
    if (uid == null) {
      setState(() => _errorMessage = 'Please login to use map.');
      return;
    }
    _currentUserId = uid;

    final context = await _mapStore.loadRealtimeContext(uid);
    if (context == null) return;

    _applyProfiles(context.profiles, context.friendIds);
    _subscribeToUserLocations(context.allTrackedIds);
    _subscribeToMatchLocations(context.matchInfo.matchIds);
  }

  void _applyProfiles(List<MapProfileEntity> profiles, Set<String> friendIds) {
    if (profiles.isEmpty) return;
    setState(() {
      _trackedUsers.clear();
      for (final profile in profiles) {
        final existing = _trackedUsers[profile.id];
        _trackedUsers[profile.id] = TrackedUserEntity(
          id: profile.id,
          displayName: profile.displayName,
          avatarUrl: profile.avatarUrl,
          relation: profile.relation,
          isOnline: profile.isOnline,
          lastActive: profile.lastActive,
          location: existing?.location,
          heading: existing?.heading,
        );
      }
    });
  }

  void _subscribeToUserLocations(Set<String> ids) {
    _userLocationsSub?.cancel();
    if (ids.isEmpty) return;
    _userLocationsSub =
        _mapStore.watchUserLocations(ids).listen(_handleUserLocations);
  }

  void _subscribeToMatchLocations(Set<String> matchIds) {
    _matchLocationsSub?.cancel();
    if (matchIds.isEmpty) return;
    _matchLocationsSub =
        _mapStore.watchMatchLocations(matchIds).listen(_handleMatchLocations);
  }

  void _handleUserLocations(List<LocationEntity> locations) {
    if (_updateTrackedUserLocations(locations) && mounted) setState(() {});
  }

  void _handleMatchLocations(List<LocationEntity> locations) {
    if (_updateTrackedUserLocations(locations) && mounted) setState(() {});
  }

  bool _updateTrackedUserLocations(List<LocationEntity> locations) {
    if (locations.isEmpty) return false;
    var changed = false;
    for (final location in locations) {
      final userId = location.userId;
      if (userId == null) continue;
      final tracked = _trackedUsers[userId];
      if (tracked == null) continue;

      final loc = LatLng(location.latitude, location.longitude);
      final isNew = !_knownUserIds.contains(userId);

      _trackedUsers[userId] = tracked.copyWith(location: loc);
      _appendTrail(userId, loc);
      changed = true;

      if (isNew) {
        _knownUserIds.add(userId);
        _triggerZenlyVibration();
      }
    }
    return changed;
  }

  Future<void> _triggerZenlyVibration() async {
    final hasVibrator = (await Vibration.hasVibrator()) == true;
    if (!hasVibrator) return;
    Vibration.vibrate(pattern: [0, 60, 80, 60, 80, 120]);
  }

  // ---------------------------------------------------------------------------
  // Trail
  // ---------------------------------------------------------------------------

  void _appendTrail(String userId, LatLng location) {
    final trail = _trails[userId] ?? <LatLng>[];
    if (trail.isEmpty || _distance(trail.last, location) >= 8) {
      trail.add(location);
      if (trail.length > 25) trail.removeAt(0);
    }
    _trails[userId] = trail;

    if (trail.length >= 2) {
      final prev = trail[trail.length - 2];
      final heading = _distance.bearing(prev, trail.last);
      final tracked = _trackedUsers[userId];
      if (tracked != null) {
        _trackedUsers[userId] = tracked.copyWith(heading: heading);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Location
  // ---------------------------------------------------------------------------

  void _startLocationTracking() async {
    final permission = await Permission.locationWhenInUse.request();
    if (!permission.isGranted) return;

    _positionSub?.cancel();
    _positionSub = geolocator.Geolocator.getPositionStream(
      locationSettings: const geolocator.LocationSettings(
        accuracy: geolocator.LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) {
      final loc = LatLng(position.latitude, position.longitude);
      runInAction(() => _mapStore.currentLocation = loc);
    });
  }

  Future<void> _centerOnUser() async {
    setState(() {
      _isLocating = true;
      _followUser = true;
    });

    final permission = await Permission.locationWhenInUse.request();
    if (!permission.isGranted) {
      if (!mounted) return;
      setState(() {
        _isLocating = false;
        _errorMessage = 'Location permission denied';
      });
      return;
    }

    await _mapStore.fetchCurrentLocation();
    if (mounted) setState(() => _isLocating = false);
  }

  void _handleMyLocation(LatLng? location) {
    if (location == null) return;
    _appendTrail(_currentUserId ?? '', location);
    _maybeUploadLocation(location);
    if (_followUser) {
      _mapController.move(location, _mapController.camera.zoom);
    }
  }

  void _maybeUploadLocation(LatLng location) {
    final now = DateTime.now();
    if (_lastUploadAt != null &&
        now.difference(_lastUploadAt!) < const Duration(seconds: 3)) {
      if (_lastUploadLocation != null &&
          _distance(_lastUploadLocation!, location) < 5) return;
    }
    _lastUploadAt = now;
    _lastUploadLocation = location;
    _mapStore.updateUserLocation(location.latitude, location.longitude);
  }

  // ---------------------------------------------------------------------------
  // Gift
  // ---------------------------------------------------------------------------

  void _onMarkerTap(TrackedUserEntity user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _GiftPickerSheet(
        user: user,
        onGiftSelected: (gift) {
          Navigator.of(context).pop();
          _throwGift(gift, user);
        },
      ),
    );
  }

  void _throwGift(String gift, TrackedUserEntity user) {
    if (user.location == null) return;

    // Calculate screen position of target marker
    final screenSize = MediaQuery.of(context).size;
    final center = Offset(screenSize.width / 2, screenSize.height / 2);

    // Approximate target offset — marker is somewhere on screen
    // We animate from screen center toward the marker's map position
    final camera = _mapController.camera;
    final targetPoint = camera.latLngToScreenPoint(user.location!);
    final targetOffset = Offset(targetPoint.x, targetPoint.y);

    _throwController?.dispose();
    _throwController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _throwAnim = Tween<Offset>(
      begin: center,
      end: targetOffset,
    ).animate(CurvedAnimation(
      parent: _throwController!,
      curve: Curves.easeInBack,
    ));

    setState(() {
      _throwingGift = gift;
    });

    _throwController!.forward().then((_) {
      setState(() => _throwingGift = null);
      _throwController?.dispose();
      _throwController = null;
      _doSendGift(gift, user);
    });
  }

  Future<void> _doSendGift(String gift, TrackedUserEntity user) async {
    final myLoc = _mapStore.currentLocation;
    if (myLoc == null || user.location == null) return;

    try {
      await _sendMapGift(
        receiverId: user.id,
        giftType: gift,
        senderLat: myLoc.latitude,
        senderLng: myLoc.longitude,
        receiverLat: user.location!.latitude,
        receiverLng: user.location!.longitude,
      );
    } catch (e) {
      debugPrint('[MapPage] ❌ Gift send error: $e');
      if (mounted) {
        setState(() => _errorMessage = 'Failed to send gift: $e');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final mapboxToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
    final tileUrl = mapboxToken.isNotEmpty
        ? 'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}?access_token=$mapboxToken'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(_fallbackLat, _fallbackLng),
              initialZoom: 13.0,
              onPositionChanged: (_, hasGesture) {
                if (hasGesture) setState(() => _followUser = false);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: tileUrl,
                userAgentPackageName: 'com.example.prj_final_prm',
              ),
              PolylineLayer(polylines: _buildTrails()),
              MarkerLayer(markers: _buildMarkers()),
            ],
          ),

          // Back button
          Positioned(
            top: topPadding + 12,
            left: 16,
            child: _BackButton(),
          ),

          // Error banner
          if (_errorMessage != null)
            Positioned(
              top: topPadding + 64,
              left: 16,
              right: 16,
              child: _ErrorBanner(message: _errorMessage!),
            ),

          // Loading indicator
          Observer(
            builder: (_) {
              if (!_isLocating && !_mapStore.isLoading) {
                return const SizedBox.shrink();
              }
              return Positioned(
                top: topPadding + 12,
                right: 16,
                child: _LoadingChip(),
              );
            },
          ),

          // Center on user FAB
          Positioned(
            right: 16,
            bottom: 24 + bottomPadding,
            child: _LocationFab(
              onTap: _centerOnUser,
              following: _followUser,
            ),
          ),

          // Gift throw animation overlay
          if (_throwingGift != null && _throwAnim != null)
            AnimatedBuilder(
              animation: _throwAnim!,
              builder: (_, __) {
                final pos = _throwAnim!.value;
                return Positioned(
                  left: pos.dx - 20,
                  top: pos.dy - 20,
                  child: IgnorePointer(
                    child: Text(
                      _throwingGift!,
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  List<Polyline> _buildTrails() {
    return _trails.entries
        .where((e) => e.value.length >= 2)
        .map((e) => Polyline(
              points: e.value,
              color: e.key == _currentUserId
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : Colors.blueAccent.withValues(alpha: 0.35),
              strokeWidth: 3.0,
            ))
        .toList();
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    for (final user in _trackedUsers.values) {
      if (user.location == null) continue;
      markers.add(
        Marker(
          point: user.location!,
          width: 80,
          height: 90,
          child: GestureDetector(
            onTap: () => _onMarkerTap(user),
            child: _AnimatedUserMarker(
              user: user,
              pulseAnimation: _pulseAnimation,
            ),
          ),
        ),
      );
    }

    final myLocation = _mapStore.currentLocation;
    if (myLocation != null) {
      markers.add(
        Marker(
          point: myLocation,
          width: 60,
          height: 60,
          child: _MyLocationMarker(pulseAnimation: _pulseAnimation),
        ),
      );
    }

    return markers;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _throwController?.dispose();
    _locationDisposer?.call();
    _positionSub?.cancel();
    _userLocationsSub?.cancel();
    _matchLocationsSub?.cancel();
    _mapController.dispose();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Gift Picker Bottom Sheet
// ---------------------------------------------------------------------------

class _GiftPickerSheet extends StatelessWidget {
  const _GiftPickerSheet({required this.user, required this.onGiftSelected});

  final TrackedUserEntity user;
  final void Function(String gift) onGiftSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Ném quà cho ${user.displayName}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: _kGifts
                .map((gift) => GestureDetector(
                      onTap: () => onGiftSelected(gift),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            gift,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Animated User Marker (Zenly style)
// ---------------------------------------------------------------------------

class _AnimatedUserMarker extends StatelessWidget {
  const _AnimatedUserMarker({required this.user, required this.pulseAnimation});

  final TrackedUserEntity user;
  final Animation<double> pulseAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (_, __) {
        final pulse = pulseAnimation.value;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (user.isOnline)
                    Opacity(
                      opacity: (1 - pulse).clamp(0.0, 1.0),
                      child: Container(
                        width: 56 + pulse * 12,
                        height: 56 + pulse * 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.greenAccent.withValues(alpha: 0.6),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: user.isOnline ? Colors.greenAccent : Colors.grey,
                        width: 2.5,
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: user.avatarUrl != null
                          ? Image.network(
                              user.avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person,
                                size: 22,
                                color: Colors.grey,
                              ),
                            )
                          : const Icon(Icons.person, size: 22, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                user.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// My Location Marker
// ---------------------------------------------------------------------------

class _MyLocationMarker extends StatelessWidget {
  const _MyLocationMarker({required this.pulseAnimation});

  final Animation<double> pulseAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (_, __) {
        final pulse = pulseAnimation.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: (1 - pulse).clamp(0.0, 1.0),
              child: Container(
                width: 44 + pulse * 16,
                height: 44 + pulse * 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Back Button
// ---------------------------------------------------------------------------

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: Colors.black87,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Location FAB
// ---------------------------------------------------------------------------

class _LocationFab extends StatelessWidget {
  const _LocationFab({required this.onTap, required this.following});

  final VoidCallback onTap;
  final bool following;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: following ? AppColors.primary : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.my_location_rounded,
          color: following ? Colors.white : AppColors.primary,
          size: 22,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error Banner
// ---------------------------------------------------------------------------

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading Chip
// ---------------------------------------------------------------------------

class _LoadingChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 6),
          Text('Locating...', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
