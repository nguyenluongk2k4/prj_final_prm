enum FriendStatus {
  pending,
  accepted,
  rejected,
}

class FriendProfile {
  final String friendId;
  final String name;
  final String? avatarUrl;
  final FriendStatus status;
  final DateTime createdAt;

  const FriendProfile({
    required this.friendId,
    required this.name,
    this.avatarUrl,
    required this.status,
    required this.createdAt,
  });
}
