import 'package:supabase_flutter/supabase_flutter.dart';

abstract class TypingRepository {
  RealtimeChannel createChannel({
    required String myId,
    required String otherId,
  });

  Stream<bool> subscribeTyping({
    required RealtimeChannel channel,
    required String myId,
    required String otherId,
  });

  Future<void> sendTyping({
    required RealtimeChannel channel,
    required String myId,
    required String otherId,
    required bool isTyping,
  });

  void disposeChannel(RealtimeChannel channel);
}
