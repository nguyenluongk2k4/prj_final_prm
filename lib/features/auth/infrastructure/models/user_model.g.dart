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
  avatarUrl: json['avatar_url'] as String?,
  preferences: (json['preferences'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  gender: json['gender'] as String?,
  targetGender: json['target_gender'] as String?,
  bio: json['bio'] as String?,
  birthDate: json['birth_date'] == null
      ? null
      : DateTime.parse(json['birth_date'] as String),
  provinceId: (json['province_id'] as num?)?.toInt(),
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  isOnline: json['is_online'] as bool? ?? false,
  lastActive: json['last_active'] == null
      ? null
      : DateTime.parse(json['last_active'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'phone': instance.phone,
  'avatar_url': instance.avatarUrl,
  'preferences': instance.preferences,
  'gender': instance.gender,
  'target_gender': instance.targetGender,
  'bio': instance.bio,
  'birth_date': instance.birthDate?.toIso8601String(),
  'province_id': instance.provinceId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'is_online': instance.isOnline,
  'last_active': instance.lastActive?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
