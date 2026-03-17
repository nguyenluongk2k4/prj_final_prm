import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_entity.freezed.dart';
part 'location_entity.g.dart';

@freezed
class LocationEntity with _$LocationEntity {
  const factory LocationEntity({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
    String? userId,
    String? matchId,
  }) = _LocationEntity;

  factory LocationEntity.fromJson(Map<String, dynamic> json) =>
      _$LocationEntityFromJson(json);
}
