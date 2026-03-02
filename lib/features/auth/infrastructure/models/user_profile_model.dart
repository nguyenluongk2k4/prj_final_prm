import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  UserProfileModel({
    required super.id,
    required super.displayName,
    super.bio,
    super.gender,
    super.targetGender,
    super.birthDate,
    super.avatarUrl,
    super.isOnline = false,
    required super.lastActive,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      bio: json['bio'] as String?,
      gender: json['gender'] as String?,
      targetGender: json['target_gender'] as String?,
      birthDate: json['birth_date'] != null ? DateTime.parse(json['birth_date']) : null,
      avatarUrl: json['avatar_url'] as String?,
      isOnline: json['is_online'] as bool? ?? false,
      lastActive: json['last_active'] != null 
          ? DateTime.parse(json['last_active']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'bio': bio,
      'gender': gender,
      'target_gender': targetGender,
      'birth_date': birthDate?.toIso8601String(),
      'avatar_url': avatarUrl,
      'is_online': isOnline,
      'last_active': lastActive.toIso8601String(),
    };
  }
}
