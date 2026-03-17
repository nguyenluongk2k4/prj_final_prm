import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/location_entity.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
class LocationModel with _$LocationModel {
  const factory LocationModel({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
    String? userId,
    String? matchId,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      timestamp: entity.timestamp,
      userId: entity.userId,
      matchId: entity.matchId,
    );
  }
}

extension LocationModelX on LocationModel {
  LocationEntity toEntity() {
    return LocationEntity(
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
      userId: userId,
      matchId: matchId,
    );
  }
}
