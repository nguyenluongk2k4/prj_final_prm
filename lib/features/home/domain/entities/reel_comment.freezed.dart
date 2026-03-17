// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reel_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReelComment _$ReelCommentFromJson(Map<String, dynamic> json) {
  return _ReelComment.fromJson(json);
}

/// @nodoc
mixin _$ReelComment {
  String get id => throw _privateConstructorUsedError;
  String get reelId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  ReelAuthor? get user => throw _privateConstructorUsedError;

  /// Serializes this ReelComment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReelComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReelCommentCopyWith<ReelComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReelCommentCopyWith<$Res> {
  factory $ReelCommentCopyWith(
    ReelComment value,
    $Res Function(ReelComment) then,
  ) = _$ReelCommentCopyWithImpl<$Res, ReelComment>;
  @useResult
  $Res call({
    String id,
    String reelId,
    String userId,
    String content,
    DateTime createdAt,
    String? parentId,
    ReelAuthor? user,
  });

  $ReelAuthorCopyWith<$Res>? get user;
}

/// @nodoc
class _$ReelCommentCopyWithImpl<$Res, $Val extends ReelComment>
    implements $ReelCommentCopyWith<$Res> {
  _$ReelCommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReelComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reelId = null,
    Object? userId = null,
    Object? content = null,
    Object? createdAt = null,
    Object? parentId = freezed,
    Object? user = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            reelId: null == reelId
                ? _value.reelId
                : reelId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as ReelAuthor?,
          )
          as $Val,
    );
  }

  /// Create a copy of ReelComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReelAuthorCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $ReelAuthorCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReelCommentImplCopyWith<$Res>
    implements $ReelCommentCopyWith<$Res> {
  factory _$$ReelCommentImplCopyWith(
    _$ReelCommentImpl value,
    $Res Function(_$ReelCommentImpl) then,
  ) = __$$ReelCommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reelId,
    String userId,
    String content,
    DateTime createdAt,
    String? parentId,
    ReelAuthor? user,
  });

  @override
  $ReelAuthorCopyWith<$Res>? get user;
}

/// @nodoc
class __$$ReelCommentImplCopyWithImpl<$Res>
    extends _$ReelCommentCopyWithImpl<$Res, _$ReelCommentImpl>
    implements _$$ReelCommentImplCopyWith<$Res> {
  __$$ReelCommentImplCopyWithImpl(
    _$ReelCommentImpl _value,
    $Res Function(_$ReelCommentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReelComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reelId = null,
    Object? userId = null,
    Object? content = null,
    Object? createdAt = null,
    Object? parentId = freezed,
    Object? user = freezed,
  }) {
    return _then(
      _$ReelCommentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reelId: null == reelId
            ? _value.reelId
            : reelId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as ReelAuthor?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReelCommentImpl implements _ReelComment {
  const _$ReelCommentImpl({
    required this.id,
    required this.reelId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.parentId,
    this.user,
  });

  factory _$ReelCommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReelCommentImplFromJson(json);

  @override
  final String id;
  @override
  final String reelId;
  @override
  final String userId;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  final String? parentId;
  @override
  final ReelAuthor? user;

  @override
  String toString() {
    return 'ReelComment(id: $id, reelId: $reelId, userId: $userId, content: $content, createdAt: $createdAt, parentId: $parentId, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReelCommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reelId, reelId) || other.reelId == reelId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    reelId,
    userId,
    content,
    createdAt,
    parentId,
    user,
  );

  /// Create a copy of ReelComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReelCommentImplCopyWith<_$ReelCommentImpl> get copyWith =>
      __$$ReelCommentImplCopyWithImpl<_$ReelCommentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReelCommentImplToJson(this);
  }
}

abstract class _ReelComment implements ReelComment {
  const factory _ReelComment({
    required final String id,
    required final String reelId,
    required final String userId,
    required final String content,
    required final DateTime createdAt,
    final String? parentId,
    final ReelAuthor? user,
  }) = _$ReelCommentImpl;

  factory _ReelComment.fromJson(Map<String, dynamic> json) =
      _$ReelCommentImpl.fromJson;

  @override
  String get id;
  @override
  String get reelId;
  @override
  String get userId;
  @override
  String get content;
  @override
  DateTime get createdAt;
  @override
  String? get parentId;
  @override
  ReelAuthor? get user;

  /// Create a copy of ReelComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReelCommentImplCopyWith<_$ReelCommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
