// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationEntityImpl _$$LocationEntityImplFromJson(Map<String, dynamic> json) =>
    _$LocationEntityImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      userId: json['userId'] as String?,
      matchId: json['matchId'] as String?,
    );

Map<String, dynamic> _$$LocationEntityImplToJson(
  _$LocationEntityImpl instance,
) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'timestamp': instance.timestamp.toIso8601String(),
  'userId': instance.userId,
  'matchId': instance.matchId,
};
