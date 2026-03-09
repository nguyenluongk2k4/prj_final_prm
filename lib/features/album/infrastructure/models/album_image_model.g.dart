// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumImageModel _$AlbumImageModelFromJson(Map<String, dynamic> json) =>
    AlbumImageModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      imageUrl: json['image_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AlbumImageModelToJson(AlbumImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'image_url': instance.imageUrl,
      'created_at': instance.createdAt.toIso8601String(),
    };
