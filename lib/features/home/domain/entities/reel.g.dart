// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReelImpl _$$ReelImplFromJson(Map<String, dynamic> json) => _$ReelImpl(
  id: json['id'] as String,
  authorId: json['authorId'] as String,
  videoUrl: json['videoUrl'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  description: json['description'] as String?,
  likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
  commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
  isLikedByMe: json['isLikedByMe'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  author: json['author'] == null
      ? null
      : ReelAuthor.fromJson(json['author'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ReelImplToJson(_$ReelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'videoUrl': instance.videoUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'description': instance.description,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'isLikedByMe': instance.isLikedByMe,
      'createdAt': instance.createdAt.toIso8601String(),
      'author': instance.author,
    };

_$ReelAuthorImpl _$$ReelAuthorImplFromJson(Map<String, dynamic> json) =>
    _$ReelAuthorImpl(
      id: json['id'] as String,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$$ReelAuthorImplToJson(_$ReelAuthorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
    };
