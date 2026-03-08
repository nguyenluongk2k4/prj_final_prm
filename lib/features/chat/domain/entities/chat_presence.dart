class ChatPresence {
  final bool isOnline;
  final DateTime? lastActive;

  const ChatPresence({
    required this.isOnline,
    this.lastActive,
  });
}
