import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class TypingDatasource {
  final SupabaseClient _supabase;

  TypingDatasource(this._supabase);

  String _channelName(String myId, String otherId) {
    final ids = [myId, otherId]..sort();
    return 'typing-${ids[0]}-${ids[1]}';
  }

  RealtimeChannel createChannel({
    required String myId,
    required String otherId,
  }) {
    if (kDebugMode) {
      debugPrint('[TypingDatasource] createChannel $myId <-> $otherId');
    }
    return _supabase.channel(_channelName(myId, otherId));
  }

  Stream<bool> subscribeTyping({
    required RealtimeChannel channel,
    required String myId,
    required String otherId,
  }) {
    final controller = StreamController<bool>();

    channel
        .onBroadcast(
          event: 'typing',
          callback: (payload) {
            final data = payload is Map<String, dynamic> ? payload : null;
            if (data == null) return;

            final senderId = data['sender_id'] as String?;
            final receiverId = data['receiver_id'] as String?;
            final isTyping = data['is_typing'] as bool? ?? false;

            if (senderId != otherId || receiverId != myId) return;
            if (kDebugMode) {
              debugPrint(
                '[TypingDatasource] recv typing: $senderId -> $receiverId, '
                'isTyping=$isTyping',
              );
            }
            controller.add(isTyping);
          },
        )
        .subscribe();

    return controller.stream;
  }

  Future<void> sendTyping({
    required RealtimeChannel channel,
    required String myId,
    required String otherId,
    required bool isTyping,
  }) async {
    if (kDebugMode) {
      debugPrint(
        '[TypingDatasource] send typing: $myId -> $otherId, '
        'isTyping=$isTyping',
      );
    }
    await channel.sendBroadcastMessage(
      event: 'typing',
      payload: {
        'sender_id': myId,
        'receiver_id': otherId,
        'is_typing': isTyping,
        'ts': DateTime.now().toIso8601String(),
      },
    );
  }

  void disposeChannel(RealtimeChannel channel) {
    if (kDebugMode) {
      debugPrint('[TypingDatasource] disposeChannel');
    }
    _supabase.removeChannel(channel);
  }
}
