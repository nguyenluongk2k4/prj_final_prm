import 'map_profile_entity.dart';
import 'match_info_entity.dart';

/// Contains all the context needed to initialize real-time map tracking.
/// Includes friends, matches, and their profile information.
class MapRealtimeContext {
  /// IDs of the current user's friends
  final Set<String> friendIds;

  /// Information about the user's matches
  final MatchInfoEntity matchInfo;

  /// Profile information for all tracked users (friends + matches)
  final List<MapProfileEntity> profiles;

  const MapRealtimeContext({
    required this.friendIds,
    required this.matchInfo,
    required this.profiles,
  });

  /// All user IDs that should be tracked (friends + match users)
  Set<String> get allTrackedIds => {...friendIds, ...matchInfo.userIds};

  /// Total number of tracked users
  int get trackedCount => profiles.length;
}
