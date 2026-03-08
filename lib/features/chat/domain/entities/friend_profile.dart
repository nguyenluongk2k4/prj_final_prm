enum FriendStatus {
  pending,
  accepted,
  rejected,
}

enum LastMessageType {
  text,
  image,
  file,
  voice,
  unknown,
}

class FriendProfile {
  final String friendId;
  final String name;
  final String? avatarUrl;
  final FriendStatus status;
  final DateTime createdAt;
  final bool isOnline;
  final DateTime? lastActive;
  final int chatCount;
  final DateTime? lastMessageAt;
  final LastMessageType lastMessageType;
  final String? lastMessageContent;
  final String? lastMessageSenderId;
  final bool hasReels;

  const FriendProfile({
    required this.friendId,
    required this.name,
    this.avatarUrl,
    required this.status,
    required this.createdAt,
    required this.isOnline,
    this.lastActive,
    required this.chatCount,
    this.lastMessageAt,
    required this.lastMessageType,
    this.lastMessageContent,
    this.lastMessageSenderId,
    required this.hasReels,
  });
}
