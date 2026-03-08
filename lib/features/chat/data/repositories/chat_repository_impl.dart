import 'package:injectable/injectable.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_presence.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/utils/chat_message_formatter.dart';
import '../../infrastructure/datasources/chat_messages_datasource.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatMessagesDatasource _datasource;

  ChatRepositoryImpl(this._datasource);

  @override
  Future<List<ChatMessage>> fetchMessages({
    required String myId,
    required String otherId,
  }) async {
    final records = await _datasource.fetchMessages(myId: myId, otherId: otherId);
    final messages = <ChatMessage>[];
    for (final record in records) {
      final mapped = _mapRecord(record, myId, otherId);
      if (mapped != null) messages.add(mapped);
    }
    return messages;
  }

  @override
  Future<ChatMessage> sendMessage({
    required String myId,
    required String otherId,
    required String content,
    required ChatMessageType type,
  }) async {
    final record = await _datasource.sendMessage(
      myId: myId,
      otherId: otherId,
      content: content,
      messageType: ChatMessageFormatter.toDbValue(type),
    );

    final mapped = _mapRecord(record, myId, otherId);
    if (mapped == null) {
      throw StateError('Failed to map sent message');
    }
    return mapped;
  }

  @override
  Stream<ChatMessage> subscribeMessages({
    required String myId,
    required String otherId,
  }) {
    return _datasource
        .subscribeMessages(myId: myId, otherId: otherId)
        .map((record) => _mapRecord(record, myId, otherId))
      .where((message) => message != null)
      .map((message) => message!);
  }

  @override
  Future<ChatPresence?> fetchPresence({required String userId}) async {
    final response = await _datasource.fetchPresence(userId: userId);
    if (response == null) return null;

    final lastActiveRaw = response['last_active'];
    return ChatPresence(
      isOnline: response['is_online'] ?? false,
      lastActive: lastActiveRaw != null ? DateTime.parse(lastActiveRaw) : null,
    );
  }

  ChatMessage? _mapRecord(
    Map<String, dynamic> record,
    String myId,
    String otherId,
  ) {
    if (record.isEmpty) return null;

    final id = record['id'] as String?;
    final senderId = record['sender_id'] as String?;
    final receiverId = record['receiver_id'] as String?;
    final content = record['content'] as String? ?? '';
    final messageType = record['message_type'] as String?;
    final createdAtRaw = record['created_at'] as String?;

    final isFromOther = senderId == otherId && receiverId == myId;
    final isFromMe = senderId == myId && receiverId == otherId;
    if (!isFromOther && !isFromMe) return null;

    final createdAt = createdAtRaw != null
        ? DateTime.parse(createdAtRaw).toLocal()
        : DateTime.now();
    final type = ChatMessageFormatter.parseType(messageType);
    final displayText = type == ChatMessageType.file
        ? ChatMessageFormatter.fileNameFromUrl(content)
        : content;
    final fileUrl = (type == ChatMessageType.image ||
            type == ChatMessageType.file)
        ? content
        : null;

    return ChatMessage(
      id: id,
      type: type,
      text: displayText,
      time: ChatMessageFormatter.formatTime(createdAt),
      sender: isFromMe ? ChatSender.me : ChatSender.other,
      fileUrl: fileUrl,
      createdAt: createdAt,
    );
  }
}
