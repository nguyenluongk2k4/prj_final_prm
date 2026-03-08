import '../entities/chat_message.dart';
import '../entities/chat_presence.dart';

abstract class ChatRepository {
  Future<List<ChatMessage>> fetchMessages({
    required String myId,
    required String otherId,
  });

  Future<ChatMessage> sendMessage({
    required String myId,
    required String otherId,
    required String content,
    required ChatMessageType type,
  });

  Stream<ChatMessage> subscribeMessages({
    required String myId,
    required String otherId,
  });

  Future<ChatPresence?> fetchPresence({
    required String userId,
  });
}
