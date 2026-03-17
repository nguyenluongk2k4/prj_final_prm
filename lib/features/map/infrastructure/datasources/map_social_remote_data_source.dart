import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/map_profile_entity.dart';
import '../../domain/entities/map_relation.dart';
import '../../domain/entities/match_info_entity.dart';
import '../models/location_model.dart';

abstract class IMapSocialRemoteDataSource {
  Future<Set<String>> fetchFriendIds(String userId);
  Future<MatchInfoEntity> fetchMatchInfo(String userId);
  Future<List<MapProfileEntity>> fetchProfiles({
    required Set<String> ids,
    required Set<String> friendIds,
    required Set<String> matchUserIds,
  });
  Stream<List<LocationModel>> streamUserLocations(Set<String> userIds);
  Stream<List<LocationModel>> streamMatchLocations(Set<String> matchIds);
}

class MapSocialRemoteDataSourceImpl implements IMapSocialRemoteDataSource {
  final SupabaseClient _supabase;

  MapSocialRemoteDataSourceImpl(this._supabase);

  @override
  Future<Set<String>> fetchFriendIds(String userId) async {
    final rows = await _supabase
        .from('friends')
        .select('user1_id, user2_id, status')
        .eq('status', 'accepted')
        .or('user1_id.eq.$userId,user2_id.eq.$userId');

    final ids = <String>{};
    for (final row in rows) {
      final u1 = row['user1_id'] as String?;
      final u2 = row['user2_id'] as String?;
      if (u1 == null || u2 == null) continue;
      ids.add(u1 == userId ? u2 : u1);
    }
    return ids;
  }

  @override
  Future<MatchInfoEntity> fetchMatchInfo(String userId) async {
    final rows = await _supabase
        .from('matches')
        .select('id, user1_id, user2_id')
        .or('user1_id.eq.$userId,user2_id.eq.$userId');

    final matchIds = <String>{};
    final userIds = <String>{};
    for (final row in rows) {
      final matchId = row['id'] as String?;
      final u1 = row['user1_id'] as String?;
      final u2 = row['user2_id'] as String?;
      if (matchId != null) matchIds.add(matchId);
      if (u1 == null || u2 == null) continue;
      userIds.add(u1 == userId ? u2 : u1);
    }
    return MatchInfoEntity(matchIds: matchIds, userIds: userIds);
  }

  @override
  Future<List<MapProfileEntity>> fetchProfiles({
    required Set<String> ids,
    required Set<String> friendIds,
    required Set<String> matchUserIds,
  }) async {
    if (ids.isEmpty) return <MapProfileEntity>[];

    final profileRows = await _supabase
        .from('profiles')
        .select('user_id, display_name, avatar_url, is_online, last_active')
        .inFilter('user_id', ids.toList());

    final userRows = await _supabase
        .from('users')
        .select('id, name, avatar_url')
        .inFilter('id', ids.toList());

    final profileMap = <String, Map<String, dynamic>>{};
    for (final row in profileRows) {
      final id = row['user_id'] as String?;
      if (id != null) profileMap[id] = row;
    }

    final userMap = <String, Map<String, dynamic>>{};
    for (final row in userRows) {
      final id = row['id'] as String?;
      if (id != null) userMap[id] = row;
    }

    final profiles = <MapProfileEntity>[];
    for (final id in ids) {
      final profile = profileMap[id];
      final user = userMap[id];
      final displayName =
          (profile?['display_name'] as String?) ??
              (user?['name'] as String?) ??
              'User';
      final avatarUrl =
          (profile?['avatar_url'] as String?) ??
              (user?['avatar_url'] as String?);
      final isOnline = (profile?['is_online'] as bool?) ?? false;
      final lastActiveRaw = profile?['last_active'];
      DateTime? lastActive;
      if (lastActiveRaw is String) {
        lastActive = DateTime.tryParse(lastActiveRaw);
      } else if (lastActiveRaw is DateTime) {
        lastActive = lastActiveRaw;
      }

      final relation = friendIds.contains(id)
          ? MapRelation.friend
          : MapRelation.match;

      profiles.add(
        MapProfileEntity(
          id: id,
          displayName: displayName,
          avatarUrl: avatarUrl,
          isOnline: isOnline,
          lastActive: lastActive,
          relation: relation,
        ),
      );
    }

    return profiles;
  }

  @override
  Stream<List<LocationModel>> streamUserLocations(Set<String> userIds) {
    if (userIds.isEmpty) {
      return const Stream.empty();
    }

    return _supabase
        .from('user_locations')
        .stream(primaryKey: ['user_id'])
        .inFilter('user_id', userIds.toList())
        .map(_mapLocations);
  }

  @override
  Stream<List<LocationModel>> streamMatchLocations(Set<String> matchIds) {
    if (matchIds.isEmpty) {
      return const Stream.empty();
    }

    return _supabase
        .from('match_locations')
        .stream(primaryKey: ['user_id', 'match_id'])
        .inFilter('match_id', matchIds.toList())
        .map(_mapLocations);
  }

  List<LocationModel> _mapLocations(List<Map<String, dynamic>> rows) {
    return rows
        .map(
          (row) {
            final rawTimestamp = row['timestamp'];
            DateTime timestamp;
            if (rawTimestamp is String) {
              timestamp = DateTime.parse(rawTimestamp);
            } else if (rawTimestamp is DateTime) {
              timestamp = rawTimestamp;
            } else {
              timestamp = DateTime.now();
            }

            return LocationModel(
              latitude: (row['latitude'] as num).toDouble(),
              longitude: (row['longitude'] as num).toDouble(),
              timestamp: timestamp,
              userId: row['user_id'] as String?,
              matchId: row['match_id'] as String?,
            );
          },
        )
        .toList();
  }
}
