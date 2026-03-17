// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Reel _$ReelFromJson(Map<String, dynamic> json) {
  return _Reel.fromJson(json);
}

/// @nodoc
mixin _$Reel {
  String get id => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;

  /// For videos this holds the video URL; for photo posts it is empty string.
  String get videoUrl => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// 'video' or 'image'
  String get mediaType => throw _privateConstructorUsedError;
  String? get audioUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  int get commentsCount => throw _privateConstructorUsedError;
  bool get isLikedByMe => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  ReelAuthor? get author => throw _privateConstructorUsedError;

  /// Serializes this Reel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Reel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReelCopyWith<Reel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReelCopyWith<$Res> {
  factory $ReelCopyWith(Reel value, $Res Function(Reel) then) =
      _$ReelCopyWithImpl<$Res, Reel>;
  @useResult
  $Res call({
    String id,
    String authorId,
    String videoUrl,
    String? thumbnailUrl,
    String? imageUrl,
    String mediaType,
    String? audioUrl,
    String? description,
    int likesCount,
    int commentsCount,
    bool isLikedByMe,
    DateTime createdAt,
    ReelAuthor? author,
  });

  $ReelAuthorCopyWith<$Res>? get author;
}

/// @nodoc
class _$ReelCopyWithImpl<$Res, $Val extends Reel>
    implements $ReelCopyWith<$Res> {
  _$ReelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? videoUrl = null,
    Object? thumbnailUrl = freezed,
    Object? imageUrl = freezed,
    Object? mediaType = null,
    Object? audioUrl = freezed,
    Object? description = freezed,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? isLikedByMe = null,
    Object? createdAt = null,
    Object? author = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            authorId: null == authorId
                ? _value.authorId
                : authorId // ignore: cast_nullable_to_non_nullable
                      as String,
            videoUrl: null == videoUrl
                ? _value.videoUrl
                : videoUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            mediaType: null == mediaType
                ? _value.mediaType
                : mediaType // ignore: cast_nullable_to_non_nullable
                      as String,
            audioUrl: freezed == audioUrl
                ? _value.audioUrl
                : audioUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            likesCount: null == likesCount
                ? _value.likesCount
                : likesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            commentsCount: null == commentsCount
                ? _value.commentsCount
                : commentsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isLikedByMe: null == isLikedByMe
                ? _value.isLikedByMe
                : isLikedByMe // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            author: freezed == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as ReelAuthor?,
          )
          as $Val,
    );
  }

  /// Create a copy of Reel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReelAuthorCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $ReelAuthorCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReelImplCopyWith<$Res> implements $ReelCopyWith<$Res> {
  factory _$$ReelImplCopyWith(
    _$ReelImpl value,
    $Res Function(_$ReelImpl) then,
  ) = __$$ReelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String authorId,
    String videoUrl,
    String? thumbnailUrl,
    String? imageUrl,
    String mediaType,
    String? audioUrl,
    String? description,
    int likesCount,
    int commentsCount,
    bool isLikedByMe,
    DateTime createdAt,
    ReelAuthor? author,
  });

  @override
  $ReelAuthorCopyWith<$Res>? get author;
}

/// @nodoc
class __$$ReelImplCopyWithImpl<$Res>
    extends _$ReelCopyWithImpl<$Res, _$ReelImpl>
    implements _$$ReelImplCopyWith<$Res> {
  __$$ReelImplCopyWithImpl(_$ReelImpl _value, $Res Function(_$ReelImpl) _then)
    : super(_value, _then);

  /// Create a copy of Reel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? videoUrl = null,
    Object? thumbnailUrl = freezed,
    Object? imageUrl = freezed,
    Object? mediaType = null,
    Object? audioUrl = freezed,
    Object? description = freezed,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? isLikedByMe = null,
    Object? createdAt = null,
    Object? author = freezed,
  }) {
    return _then(
      _$ReelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        authorId: null == authorId
            ? _value.authorId
            : authorId // ignore: cast_nullable_to_non_nullable
                  as String,
        videoUrl: null == videoUrl
            ? _value.videoUrl
            : videoUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        mediaType: null == mediaType
            ? _value.mediaType
            : mediaType // ignore: cast_nullable_to_non_nullable
                  as String,
        audioUrl: freezed == audioUrl
            ? _value.audioUrl
            : audioUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        likesCount: null == likesCount
            ? _value.likesCount
            : likesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        commentsCount: null == commentsCount
            ? _value.commentsCount
            : commentsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isLikedByMe: null == isLikedByMe
            ? _value.isLikedByMe
            : isLikedByMe // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        author: freezed == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as ReelAuthor?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReelImpl extends _Reel {
  const _$ReelImpl({
    required this.id,
    required this.authorId,
    this.videoUrl = '',
    this.thumbnailUrl,
    this.imageUrl,
    this.mediaType = 'video',
    this.audioUrl,
    this.description,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLikedByMe = false,
    required this.createdAt,
    this.author,
  }) : super._();

  factory _$ReelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReelImplFromJson(json);

  @override
  final String id;
  @override
  final String authorId;

  /// For videos this holds the video URL; for photo posts it is empty string.
  @override
  @JsonKey()
  final String videoUrl;
  @override
  final String? thumbnailUrl;
  @override
  final String? imageUrl;

  /// 'video' or 'image'
  @override
  @JsonKey()
  final String mediaType;
  @override
  final String? audioUrl;
  @override
  final String? description;
  @override
  @JsonKey()
  final int likesCount;
  @override
  @JsonKey()
  final int commentsCount;
  @override
  @JsonKey()
  final bool isLikedByMe;
  @override
  final DateTime createdAt;
  @override
  final ReelAuthor? author;

  @override
  String toString() {
    return 'Reel(id: $id, authorId: $authorId, videoUrl: $videoUrl, thumbnailUrl: $thumbnailUrl, imageUrl: $imageUrl, mediaType: $mediaType, audioUrl: $audioUrl, description: $description, likesCount: $likesCount, commentsCount: $commentsCount, isLikedByMe: $isLikedByMe, createdAt: $createdAt, author: $author)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.isLikedByMe, isLikedByMe) ||
                other.isLikedByMe == isLikedByMe) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.author, author) || other.author == author));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    authorId,
    videoUrl,
    thumbnailUrl,
    imageUrl,
    mediaType,
    audioUrl,
    description,
    likesCount,
    commentsCount,
    isLikedByMe,
    createdAt,
    author,
  );

  /// Create a copy of Reel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReelImplCopyWith<_$ReelImpl> get copyWith =>
      __$$ReelImplCopyWithImpl<_$ReelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReelImplToJson(this);
  }
}

abstract class _Reel extends Reel {
  const factory _Reel({
    required final String id,
    required final String authorId,
    final String videoUrl,
    final String? thumbnailUrl,
    final String? imageUrl,
    final String mediaType,
    final String? audioUrl,
    final String? description,
    final int likesCount,
    final int commentsCount,
    final bool isLikedByMe,
    required final DateTime createdAt,
    final ReelAuthor? author,
  }) = _$ReelImpl;
  const _Reel._() : super._();

  factory _Reel.fromJson(Map<String, dynamic> json) = _$ReelImpl.fromJson;

  @override
  String get id;
  @override
  String get authorId;

  /// For videos this holds the video URL; for photo posts it is empty string.
  @override
  String get videoUrl;
  @override
  String? get thumbnailUrl;
  @override
  String? get imageUrl;

  /// 'video' or 'image'
  @override
  String get mediaType;
  @override
  String? get audioUrl;
  @override
  String? get description;
  @override
  int get likesCount;
  @override
  int get commentsCount;
  @override
  bool get isLikedByMe;
  @override
  DateTime get createdAt;
  @override
  ReelAuthor? get author;

  /// Create a copy of Reel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReelImplCopyWith<_$ReelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReelAuthor _$ReelAuthorFromJson(Map<String, dynamic> json) {
  return _ReelAuthor.fromJson(json);
}

/// @nodoc
mixin _$ReelAuthor {
  String get id => throw _privateConstructorUsedError;
  String? get displayName =>
      throw _privateConstructorUsedError; // nullable: user may not have set a name yet
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// Serializes this ReelAuthor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReelAuthor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReelAuthorCopyWith<ReelAuthor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReelAuthorCopyWith<$Res> {
  factory $ReelAuthorCopyWith(
    ReelAuthor value,
    $Res Function(ReelAuthor) then,
  ) = _$ReelAuthorCopyWithImpl<$Res, ReelAuthor>;
  @useResult
  $Res call({String id, String? displayName, String? avatarUrl});
}

/// @nodoc
class _$ReelAuthorCopyWithImpl<$Res, $Val extends ReelAuthor>
    implements $ReelAuthorCopyWith<$Res> {
  _$ReelAuthorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReelAuthor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReelAuthorImplCopyWith<$Res>
    implements $ReelAuthorCopyWith<$Res> {
  factory _$$ReelAuthorImplCopyWith(
    _$ReelAuthorImpl value,
    $Res Function(_$ReelAuthorImpl) then,
  ) = __$$ReelAuthorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String? displayName, String? avatarUrl});
}

/// @nodoc
class __$$ReelAuthorImplCopyWithImpl<$Res>
    extends _$ReelAuthorCopyWithImpl<$Res, _$ReelAuthorImpl>
    implements _$$ReelAuthorImplCopyWith<$Res> {
  __$$ReelAuthorImplCopyWithImpl(
    _$ReelAuthorImpl _value,
    $Res Function(_$ReelAuthorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReelAuthor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(
      _$ReelAuthorImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReelAuthorImpl implements _ReelAuthor {
  const _$ReelAuthorImpl({required this.id, this.displayName, this.avatarUrl});

  factory _$ReelAuthorImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReelAuthorImplFromJson(json);

  @override
  final String id;
  @override
  final String? displayName;
  // nullable: user may not have set a name yet
  @override
  final String? avatarUrl;

  @override
  String toString() {
    return 'ReelAuthor(id: $id, displayName: $displayName, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReelAuthorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, displayName, avatarUrl);

  /// Create a copy of ReelAuthor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReelAuthorImplCopyWith<_$ReelAuthorImpl> get copyWith =>
      __$$ReelAuthorImplCopyWithImpl<_$ReelAuthorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReelAuthorImplToJson(this);
  }
}

abstract class _ReelAuthor implements ReelAuthor {
  const factory _ReelAuthor({
    required final String id,
    final String? displayName,
    final String? avatarUrl,
  }) = _$ReelAuthorImpl;

  factory _ReelAuthor.fromJson(Map<String, dynamic> json) =
      _$ReelAuthorImpl.fromJson;

  @override
  String get id;
  @override
  String? get displayName; // nullable: user may not have set a name yet
  @override
  String? get avatarUrl;

  /// Create a copy of ReelAuthor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReelAuthorImplCopyWith<_$ReelAuthorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
