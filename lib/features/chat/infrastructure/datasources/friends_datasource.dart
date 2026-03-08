import 'dart:async';

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

    final response = await _supabase.rpc(
      'get_friends_with_stats',
      params: {'p_user_id': currentUser.id},
    );

    final List<FriendProfile> friends = [];

    for (var item in response) {
      final lastMessageType = _parseLastMessageType(item['last_message_type']);
      friends.add(
        FriendProfile(
          friendId: item['friend_id'],
          name: item['name'] ?? 'Unknown',
          avatarUrl: item['avatar_url'],
          status: FriendStatus.values.firstWhere(
            (e) => e.name == item['status'],
            orElse: () => FriendStatus.pending,
          ),
          createdAt: DateTime.parse(item['created_at']),
          isOnline: item['is_online'] ?? false,
          lastActive: item['last_active'] != null
              ? DateTime.parse(item['last_active'])
              : null,
          chatCount: (item['chat_count'] as num?)?.toInt() ?? 0,
          lastMessageAt: item['last_message_at'] != null
              ? DateTime.parse(item['last_message_at'])
              : null,
          lastMessageType: lastMessageType,
          lastMessageContent: item['last_message_content'],
          lastMessageSenderId: item['last_message_sender_id'],
          hasReels: item['has_reels'] ?? false,
        ),
      );
    }

    return friends;
  }

  LastMessageType _parseLastMessageType(dynamic value) {
    switch (value) {
      case 'text':
        return LastMessageType.text;
      case 'image':
        return LastMessageType.image;
      case 'file':
        return LastMessageType.file;
      case 'voice':
        return LastMessageType.voice;
      default:
        return LastMessageType.unknown;
    }
  }

  Stream<void> watchFriendsRealtime({required String myId}) {
    final controller = StreamController<void>();
    final channel = _supabase.channel('friends-messages-$myId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'sender_id',
            value: myId,
          ),
          callback: (_) => controller.add(null),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'receiver_id',
            value: myId,
          ),
          callback: (_) => controller.add(null),
        )
        .subscribe();

    controller.onCancel = () {
      _supabase.removeChannel(channel);
      controller.close();
    };

    return controller.stream;
  }

  Future<FriendStatus?> checkFriendship({
    required String myId,
    required String otherId,
  }) async {
    // Use explicit OR to check both directions (me->them or them->me)
    // This is more robust than relying on lexicographical sorting of UUID strings in Dart.
    
    // 1. Check friends table
    final friendResponse = await _supabase
        .from('friends')
        .select('status')
        .or('and(user1_id.eq.$myId,user2_id.eq.$otherId),and(user1_id.eq.$otherId,user2_id.eq.$myId)')
        .maybeSingle();

    if (friendResponse != null) {
      final statusStr = friendResponse['status'];
      if (statusStr == null) return null;
      return FriendStatus.values.firstWhere(
        (e) => e.name == statusStr,
        orElse: () => FriendStatus.pending,
      );
    }

    // 2. Check matches table
    final matchResponse = await _supabase
        .from('matches')
        .select('status')
        .or('and(user1_id.eq.$myId,user2_id.eq.$otherId),and(user1_id.eq.$otherId,user2_id.eq.$myId)')
        .maybeSingle();

    if (matchResponse != null) {
      final statusStr = matchResponse['status'];
      if (statusStr == null) return null;
      return FriendStatus.values.firstWhere(
        (e) => e.name == statusStr,
        orElse: () => FriendStatus.pending,
      );
    }

    return null;
  }
}
