import '../entities/chat_message.dart';

class ChatMessageFormatter {
  static ChatMessageType parseType(String? value) {
    switch (value) {
      case 'image':
        return ChatMessageType.image;
      case 'file':
        return ChatMessageType.file;
      default:
        return ChatMessageType.text;
    }
  }

  static String toDbValue(ChatMessageType type) {
    switch (type) {
      case ChatMessageType.image:
        return 'image';
      case ChatMessageType.file:
        return 'file';
      case ChatMessageType.text:
      default:
        return 'text';
    }
  }

  static String fileNameFromUrl(String url) {
    if (url.isEmpty) return '';
    try {
      final uri = Uri.parse(url);
      if (uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.last;
      }
    } catch (_) {}
    return url;
  }

  static String formatTime(DateTime time) {
    final h = time.hour;
    final m = time.minute.toString().padLeft(2, '0');
    final suffix = h >= 12 ? 'PM' : 'AM';
    final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$h12:$m $suffix';
  }
}
