// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reel_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReelCommentImpl _$$ReelCommentImplFromJson(Map<String, dynamic> json) =>
    _$ReelCommentImpl(
      id: json['id'] as String,
      reelId: json['reelId'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      user: json['user'] == null
          ? null
          : ReelAuthor.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ReelCommentImplToJson(_$ReelCommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reelId': instance.reelId,
      'userId': instance.userId,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'user': instance.user,
    };
