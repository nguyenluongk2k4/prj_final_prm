class UserProfile {
  final String id; // Firebase UID
  final String displayName;
  final String? bio;
  final String? gender;
  final String? targetGender;
  final DateTime? birthDate;
  final String? avatarUrl;
  final bool isOnline;
  final DateTime lastActive;

  UserProfile({
    required this.id,
    required this.displayName,
    this.bio,
    this.gender,
    this.targetGender,
    this.birthDate,
    this.avatarUrl,
    this.isOnline = false,
    required this.lastActive,
  });
}
