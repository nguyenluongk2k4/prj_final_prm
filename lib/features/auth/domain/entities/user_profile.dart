class UserProfile {
  final String id; // profiles.id (random UUID)
  final String? userId; // profiles.user_id = auth UID (used for friends/matches queries)
  final String displayName;
  final String? bio;
  final String? gender;
  final String? targetGender;
  final DateTime? birthDate;
  final String? avatarUrl;
  final bool isOnline;
  final DateTime lastActive;

  final List<String>? interests;
  final int? provinceId;
  final double? latitude;
  final double? longitude;

  UserProfile({
    required this.id,
    this.userId,
    required this.displayName,
    this.bio,
    this.gender,
    this.targetGender,
    this.birthDate,
    this.avatarUrl,
    this.isOnline = false,
    required this.lastActive,
    this.interests,
    this.provinceId,
    this.latitude,
    this.longitude,
  });
}
