// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  preferences: (json['preferences'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  gender: json['gender'] as String?,
  targetGender: json['targetGender'] as String?,
  bio: json['bio'] as String?,
  birthDate: json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String),
  location: json['location'] as String?,
  isOnline: json['isOnline'] as bool? ?? false,
  lastActive: json['lastActive'] == null
      ? null
      : DateTime.parse(json['lastActive'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'phone': instance.phone,
  'avatarUrl': instance.avatarUrl,
  'preferences': instance.preferences,
  'gender': instance.gender,
  'targetGender': instance.targetGender,
  'bio': instance.bio,
  'birthDate': instance.birthDate?.toIso8601String(),
  'location': instance.location,
  'isOnline': instance.isOnline,
  'lastActive': instance.lastActive?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
