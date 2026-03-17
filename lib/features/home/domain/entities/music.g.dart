// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SystemMusicImpl _$$SystemMusicImplFromJson(Map<String, dynamic> json) =>
    _$SystemMusicImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String?,
      url: json['url'] as String,
      durationMs: (json['duration_ms'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SystemMusicImplToJson(_$SystemMusicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'url': instance.url,
      'duration_ms': instance.durationMs,
    };
