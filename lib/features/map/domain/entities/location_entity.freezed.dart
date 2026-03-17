// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LocationEntity _$LocationEntityFromJson(Map<String, dynamic> json) {
  return _LocationEntity.fromJson(json);
}

/// @nodoc
mixin _$LocationEntity {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get matchId => throw _privateConstructorUsedError;

  /// Serializes this LocationEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationEntityCopyWith<LocationEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationEntityCopyWith<$Res> {
  factory $LocationEntityCopyWith(
    LocationEntity value,
    $Res Function(LocationEntity) then,
  ) = _$LocationEntityCopyWithImpl<$Res, LocationEntity>;
  @useResult
  $Res call({
    double latitude,
    double longitude,
    DateTime timestamp,
    String? userId,
    String? matchId,
  });
}

/// @nodoc
class _$LocationEntityCopyWithImpl<$Res, $Val extends LocationEntity>
    implements $LocationEntityCopyWith<$Res> {
  _$LocationEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? timestamp = null,
    Object? userId = freezed,
    Object? matchId = freezed,
  }) {
    return _then(
      _value.copyWith(
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            matchId: freezed == matchId
                ? _value.matchId
                : matchId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationEntityImplCopyWith<$Res>
    implements $LocationEntityCopyWith<$Res> {
  factory _$$LocationEntityImplCopyWith(
    _$LocationEntityImpl value,
    $Res Function(_$LocationEntityImpl) then,
  ) = __$$LocationEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double latitude,
    double longitude,
    DateTime timestamp,
    String? userId,
    String? matchId,
  });
}

/// @nodoc
class __$$LocationEntityImplCopyWithImpl<$Res>
    extends _$LocationEntityCopyWithImpl<$Res, _$LocationEntityImpl>
    implements _$$LocationEntityImplCopyWith<$Res> {
  __$$LocationEntityImplCopyWithImpl(
    _$LocationEntityImpl _value,
    $Res Function(_$LocationEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? timestamp = null,
    Object? userId = freezed,
    Object? matchId = freezed,
  }) {
    return _then(
      _$LocationEntityImpl(
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        matchId: freezed == matchId
            ? _value.matchId
            : matchId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationEntityImpl implements _LocationEntity {
  const _$LocationEntityImpl({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.userId,
    this.matchId,
  });

  factory _$LocationEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationEntityImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final DateTime timestamp;
  @override
  final String? userId;
  @override
  final String? matchId;

  @override
  String toString() {
    return 'LocationEntity(latitude: $latitude, longitude: $longitude, timestamp: $timestamp, userId: $userId, matchId: $matchId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationEntityImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.matchId, matchId) || other.matchId == matchId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, latitude, longitude, timestamp, userId, matchId);

  /// Create a copy of LocationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationEntityImplCopyWith<_$LocationEntityImpl> get copyWith =>
      __$$LocationEntityImplCopyWithImpl<_$LocationEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationEntityImplToJson(this);
  }
}

abstract class _LocationEntity implements LocationEntity {
  const factory _LocationEntity({
    required final double latitude,
    required final double longitude,
    required final DateTime timestamp,
    final String? userId,
    final String? matchId,
  }) = _$LocationEntityImpl;

  factory _LocationEntity.fromJson(Map<String, dynamic> json) =
      _$LocationEntityImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  DateTime get timestamp;
  @override
  String? get userId;
  @override
  String? get matchId;

  /// Create a copy of LocationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationEntityImplCopyWith<_$LocationEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
