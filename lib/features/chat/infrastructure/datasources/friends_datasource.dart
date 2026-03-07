import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/friend_profile.dart';

@lazySingleton
class FriendsDatasource {
  final SupabaseClient _supabase;

  FriendsDatasource(this._supabase);

  Future<void> updateFriendStatus({
    required String swiperId, // Usually the current user
    required String swipedId,
    required FriendStatus status,
  }) async {
    final user1 = swiperId.compareTo(swipedId) < 0 ? swiperId : swipedId;
    final user2 = swiperId.compareTo(swipedId) < 0 ? swipedId : swiperId;

    // Instead of deleting, update the match status to preserve history
    await _supabase
        .from('matches')
        .update({'status': status.name})
        .eq('user1_id', user1)
        .eq('user2_id', user2);

    // Upsert the resolved relationship into friends table
    await _supabase.from('friends').upsert(
      {
        'user1_id': user1,
        'user2_id': user2,
        'status': status.name,
        'updated_at': DateTime.now().toIso8601String(),
      },
      onConflict: 'user1_id, user2_id',
    );
  }

  Future<List<FriendProfile>> getFriends() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return [];

    final response = await _supabase
        .from('friends')
        .select('*, user1:user1_id(id, name, avatar_url), user2:user2_id(id, name, avatar_url)')
        .or('user1_id.eq.${currentUser.id},user2_id.eq.${currentUser.id}')
        .order('updated_at', ascending: false);

    final List<FriendProfile> friends = [];

    for (var relation in response) {
      final user1 = relation['user1'];
      final user2 = relation['user2'];
      
      final isUser1Me = user1 != null && user1['id'] == currentUser.id;
      final otherUser = isUser1Me ? user2 : user1;

      if (otherUser != null) {
        friends.add(
          FriendProfile(
            friendId: otherUser['id'],
            name: otherUser['name'] ?? 'Unknown',
            avatarUrl: otherUser['avatar_url'],
            // Parse Enum from String
            status: FriendStatus.values.firstWhere(
              (e) => e.name == relation['status'],
              orElse: () => FriendStatus.pending,
            ),
            createdAt: DateTime.parse(relation['created_at']),
          )
        );
      }
    }

    return friends;
  }
}
