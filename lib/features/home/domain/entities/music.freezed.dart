// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'music.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SystemMusic _$SystemMusicFromJson(Map<String, dynamic> json) {
  return _SystemMusic.fromJson(json);
}

/// @nodoc
mixin _$SystemMusic {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get artist => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_ms')
  int? get durationMs => throw _privateConstructorUsedError;

  /// Serializes this SystemMusic to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SystemMusic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SystemMusicCopyWith<SystemMusic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemMusicCopyWith<$Res> {
  factory $SystemMusicCopyWith(
    SystemMusic value,
    $Res Function(SystemMusic) then,
  ) = _$SystemMusicCopyWithImpl<$Res, SystemMusic>;
  @useResult
  $Res call({
    String id,
    String title,
    String? artist,
    String url,
    @JsonKey(name: 'duration_ms') int? durationMs,
  });
}

/// @nodoc
class _$SystemMusicCopyWithImpl<$Res, $Val extends SystemMusic>
    implements $SystemMusicCopyWith<$Res> {
  _$SystemMusicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SystemMusic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artist = freezed,
    Object? url = null,
    Object? durationMs = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            artist: freezed == artist
                ? _value.artist
                : artist // ignore: cast_nullable_to_non_nullable
                      as String?,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            durationMs: freezed == durationMs
                ? _value.durationMs
                : durationMs // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SystemMusicImplCopyWith<$Res>
    implements $SystemMusicCopyWith<$Res> {
  factory _$$SystemMusicImplCopyWith(
    _$SystemMusicImpl value,
    $Res Function(_$SystemMusicImpl) then,
  ) = __$$SystemMusicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? artist,
    String url,
    @JsonKey(name: 'duration_ms') int? durationMs,
  });
}

/// @nodoc
class __$$SystemMusicImplCopyWithImpl<$Res>
    extends _$SystemMusicCopyWithImpl<$Res, _$SystemMusicImpl>
    implements _$$SystemMusicImplCopyWith<$Res> {
  __$$SystemMusicImplCopyWithImpl(
    _$SystemMusicImpl _value,
    $Res Function(_$SystemMusicImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SystemMusic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artist = freezed,
    Object? url = null,
    Object? durationMs = freezed,
  }) {
    return _then(
      _$SystemMusicImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        artist: freezed == artist
            ? _value.artist
            : artist // ignore: cast_nullable_to_non_nullable
                  as String?,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        durationMs: freezed == durationMs
            ? _value.durationMs
            : durationMs // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SystemMusicImpl implements _SystemMusic {
  const _$SystemMusicImpl({
    required this.id,
    required this.title,
    this.artist,
    required this.url,
    @JsonKey(name: 'duration_ms') this.durationMs,
  });

  factory _$SystemMusicImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemMusicImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? artist;
  @override
  final String url;
  @override
  @JsonKey(name: 'duration_ms')
  final int? durationMs;

  @override
  String toString() {
    return 'SystemMusic(id: $id, title: $title, artist: $artist, url: $url, durationMs: $durationMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemMusicImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, artist, url, durationMs);

  /// Create a copy of SystemMusic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemMusicImplCopyWith<_$SystemMusicImpl> get copyWith =>
      __$$SystemMusicImplCopyWithImpl<_$SystemMusicImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SystemMusicImplToJson(this);
  }
}

abstract class _SystemMusic implements SystemMusic {
  const factory _SystemMusic({
    required final String id,
    required final String title,
    final String? artist,
    required final String url,
    @JsonKey(name: 'duration_ms') final int? durationMs,
  }) = _$SystemMusicImpl;

  factory _SystemMusic.fromJson(Map<String, dynamic> json) =
      _$SystemMusicImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get artist;
  @override
  String get url;
  @override
  @JsonKey(name: 'duration_ms')
  int? get durationMs;

  /// Create a copy of SystemMusic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SystemMusicImplCopyWith<_$SystemMusicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
