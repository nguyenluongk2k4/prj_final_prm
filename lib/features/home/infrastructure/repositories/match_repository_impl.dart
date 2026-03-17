import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prj_final_prm/features/auth/infrastructure/models/user_model.dart';
import '../../domain/repositories/match_repository.dart';
import '../../domain/entities/match.dart';

@Injectable(as: MatchRepository)
class MatchRepositoryImpl implements MatchRepository {
  final SupabaseClient _supabase;

  MatchRepositoryImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<List<Match>> getMatches({
    required int limit,
    required int offset,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    try {
      // Step 1: fetch matches
      final matchRows = await _supabase
          .from('matches')
          .select('id, user1_id, user2_id, created_at')
          .or('user1_id.eq.$userId,user2_id.eq.$userId')
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      if (matchRows.isEmpty) return [];

      // Step 2: collect other-user IDs
      final otherIds = matchRows.map<String>((m) {
        return (m['user1_id'] as String) == userId
            ? m['user2_id'] as String
            : m['user1_id'] as String;
      }).toSet().toList();

      // Step 3: fetch user info (name, avatar) from users table
      final userRows = await _supabase
          .from('users')
          .select('id, name, avatar_url, created_at, updated_at')
          .inFilter('id', otherIds);

      // Also fetch profile data (online status, etc.)
      final profileRows = await _supabase
          .from('profiles')
          .select('user_id, display_name, bio, gender, birth_date, avatar_url, is_online, last_active, latitude, longitude')
          .inFilter('user_id', otherIds);

      final userMap = <String, Map<String, dynamic>>{
        for (final u in userRows) u['id'] as String: u,
      };
      final profileMap = <String, Map<String, dynamic>>{
        for (final p in profileRows) p['user_id'] as String: p,
      };

      // Step 4: assemble
      return matchRows.map<Match>((m) {
        final otherId = (m['user1_id'] as String) == userId
            ? m['user2_id'] as String
            : m['user1_id'] as String;
        final u = userMap[otherId];
        final p = profileMap[otherId];
        UserModel? otherUser;
        if (u != null) {
          otherUser = UserModel.fromJson({
            'id': u['id'],
            'email': '',
            'name': u['name'],
            'avatar_url': p?['avatar_url'] ?? u['avatar_url'],
            'gender': p?['gender'],
            'bio': p?['bio'],
            'birth_date': p?['birth_date'],
            'province_id': null,
            'latitude': p?['latitude'],
            'longitude': p?['longitude'],
            'is_online': p?['is_online'] ?? false,
            'last_active': p?['last_active'],
            'created_at': u['created_at'],
            'updated_at': u['updated_at'],
          });
        }
        return Match(
          id: m['id'],
          user1Id: m['user1_id'],
          user2Id: m['user2_id'],
          createdAt: DateTime.parse(m['created_at']),
          otherUser: otherUser,
        );
      }).toList();
    } catch (e) {
      print('❌ Error fetching matches: $e');
      throw Exception('Failed to fetch matches: $e');
    }
  }

  @override
  Future<bool> checkForNewMatch(String swipedUserId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      // Check if the swiped user has also liked/superliked current user
      final response = await _supabase
          .from('swipes')
          .select('swipe_type')
          .eq('swiper_id', swipedUserId)
          .eq('swiped_id', userId)
          .or('swipe_type.eq.like,swipe_type.eq.superlike')
          .limit(1);

      print('🔍 Checking for match: $swipedUserId liked $userId? ${response.isNotEmpty}');
      return response.isNotEmpty;
    } catch (e) {
      print('❌ Error checking for match: $e');
      return false;
    }
  }
}