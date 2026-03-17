import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class ChatMessagesDatasource {
  final SupabaseClient _supabase;

  ChatMessagesDatasource(this._supabase);

  Future<List<Map<String, dynamic>>> fetchMessages({
    required String myId,
    required String otherId,
  }) async {
    final response = await _supabase
        .from('messages')
        .select('id,sender_id,receiver_id,content,message_type,created_at')
        .or(
          'and(sender_id.eq.$myId,receiver_id.eq.$otherId),'
          'and(sender_id.eq.$otherId,receiver_id.eq.$myId)',
        )
        .order('created_at');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> sendMessage({
    required String myId,
    required String otherId,
    required String content,
    required String messageType,
  }) async {
    // user1_id < user2_id required by CHECK constraint
    final ids = [myId, otherId]..sort();
    final inserted = await _supabase
        .from('messages')
        .insert({
          'sender_id': myId,
          'receiver_id': otherId,
          'user1_id': ids[0],
          'user2_id': ids[1],
          'content': content,
          'message_type': messageType,
        })
        .select('id,created_at,sender_id,receiver_id,content,message_type')
        .single();

    return Map<String, dynamic>.from(inserted);
  }

  Stream<Map<String, dynamic>> subscribeMessages({
    required String myId,
    required String otherId,
  }) {
    final controller = StreamController<Map<String, dynamic>>.broadcast();
    final channel = _supabase.channel('messages-$myId-$otherId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'sender_id',
            value: otherId,
          ),
          callback: (payload) => controller.add(payload.newRecord),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'receiver_id',
            value: otherId,
          ),
          callback: (payload) => controller.add(payload.newRecord),
        )
        .subscribe();

    controller.onCancel = () {
      _supabase.removeChannel(channel);
      controller.close();
    };

    return controller.stream;
  }

  Future<Map<String, dynamic>?> fetchPresence({required String userId}) async {
    final response = await _supabase
        .from('profiles')
        .select('is_online,last_active')
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return Map<String, dynamic>.from(response);
  }
}
