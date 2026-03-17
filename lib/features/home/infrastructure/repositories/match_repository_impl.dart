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
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      final response = await _supabase
          .from('matches')
          .select('''
            id,
            user1_id,
            user2_id,
            created_at,
            user1:profiles!matches_user1_id_fkey(
              user_id,
              email,
              name,
              avatar_url,
              gender,
              bio,
              birth_date,
              province_id,
              latitude,
              longitude,
              is_online,
              last_active,
              created_at,
              updated_at
            ),
            user2:profiles!matches_user2_id_fkey(
              user_id,
              email,
              name,
              avatar_url,
              gender,
              bio,
              birth_date,
              province_id,
              latitude,
              longitude,
              is_online,
              last_active,
              created_at,
              updated_at
            )
          ''')
          .or('user1_id.eq.$userId,user2_id.eq.$userId')
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return response.map<Match>((matchData) {
        final user1Data = matchData['user1'] as Map<String, dynamic>?;
        final user2Data = matchData['user2'] as Map<String, dynamic>?;
        
        // Determine which user is the "other" user (not current user)
        UserModel? otherUser;
        if (user1Data != null && user1Data['user_id'] != userId) {
          otherUser = UserModel.fromJson({
            'id': user1Data['user_id'],
            'email': user1Data['email'] ?? '',
            'name': user1Data['name'],
            'avatar_url': user1Data['avatar_url'],
            'gender': user1Data['gender'],
            'bio': user1Data['bio'],
            'birth_date': user1Data['birth_date'],
            'province_id': user1Data['province_id'],
            'latitude': user1Data['latitude'],
            'longitude': user1Data['longitude'],
            'is_online': user1Data['is_online'] ?? false,
            'last_active': user1Data['last_active'],
            'created_at': user1Data['created_at'],
            'updated_at': user1Data['updated_at'],
          });
        } else if (user2Data != null && user2Data['user_id'] != userId) {
          otherUser = UserModel.fromJson({
            'id': user2Data['user_id'],
            'email': user2Data['email'] ?? '',
            'name': user2Data['name'],
            'avatar_url': user2Data['avatar_url'],
            'gender': user2Data['gender'],
            'bio': user2Data['bio'],
            'birth_date': user2Data['birth_date'],
            'province_id': user2Data['province_id'],
            'latitude': user2Data['latitude'],
            'longitude': user2Data['longitude'],
            'is_online': user2Data['is_online'] ?? false,
            'last_active': user2Data['last_active'],
            'created_at': user2Data['created_at'],
            'updated_at': user2Data['updated_at'],
          });
        }

        return Match(
          id: matchData['id'],
          user1Id: matchData['user1_id'],
          user2Id: matchData['user2_id'],
          createdAt: DateTime.parse(matchData['created_at']),
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