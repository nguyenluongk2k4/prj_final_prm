enum ChatSender { me, other }

enum ChatMessageType { text, image, file }

class ChatMessage {
  final String? id;
  final ChatMessageType type;
  final String text; // text content, or filename for image/file messages
  final String time;
  final ChatSender sender;
  final String? filePath; // local path for picked image/file
  final String? fileUrl; // remote url for uploaded image/file
  final DateTime? createdAt;

  const ChatMessage({
    this.id,
    this.type = ChatMessageType.text,
    required this.text,
    required this.time,
    required this.sender,
    this.filePath,
    this.fileUrl,
    this.createdAt,
  });
}
