import 'package:latlong2/latlong.dart';
import 'map_relation.dart';

/// Represents a user being tracked on the map with their current state.
/// Extends the basic profile info with real-time location data.
class TrackedUserEntity {
  final String id;
  final String displayName;
  final String? avatarUrl;
  final MapRelation relation;
  final bool isOnline;
  final DateTime? lastActive;

  /// Current location on the map (nullable until first update)
  final LatLng? location;

  /// Direction of movement in degrees (0-360)
  final double? heading;

  const TrackedUserEntity({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
    required this.relation,
    required this.isOnline,
    required this.lastActive,
    this.location,
    this.heading,
  });

  /// Creates a copy with updated location/heading
  TrackedUserEntity copyWith({
    String? id,
    String? displayName,
    String? avatarUrl,
    MapRelation? relation,
    bool? isOnline,
    DateTime? lastActive,
    LatLng? location,
    double? heading,
  }) {
    return TrackedUserEntity(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      relation: relation ?? this.relation,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      location: location ?? this.location,
      heading: heading ?? this.heading,
    );
  }

  /// Whether this is the current user
  bool get isCurrentUser => relation == MapRelation.self;

  /// Whether this user is a friend
  bool get isFriend => relation == MapRelation.friend;

  /// Whether this user is a match
  bool get isMatch => relation == MapRelation.match;
}
