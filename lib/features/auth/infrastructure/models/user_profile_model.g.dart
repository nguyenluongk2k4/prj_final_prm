// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      bio: json['bio'] as String?,
      gender: json['gender'] as String?,
      targetGender: json['target_gender'] as String?,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      avatarUrl: json['avatar_url'] as String?,
      isOnline: json['is_online'] as bool? ?? false,
      lastActive: DateTime.parse(json['last_active'] as String),
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'bio': instance.bio,
      'gender': instance.gender,
      'target_gender': instance.targetGender,
      'birth_date': instance.birthDate?.toIso8601String(),
      'avatar_url': instance.avatarUrl,
      'is_online': instance.isOnline,
      'last_active': instance.lastActive.toIso8601String(),
    };
