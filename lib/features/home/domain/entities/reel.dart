import 'package:freezed_annotation/freezed_annotation.dart';

part 'reel.freezed.dart';
part 'reel.g.dart';

@freezed
class Reel with _$Reel {
  const Reel._();

  const factory Reel({
    required String id,
    required String authorId,
    /// For videos this holds the video URL; for photo posts it is empty string.
    @Default('') String videoUrl,
    String? thumbnailUrl,
    String? imageUrl,
    /// 'video' or 'image'
    @Default('video') String mediaType,
    String? audioUrl,
    String? description,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(false) bool isLikedByMe,
    required DateTime createdAt,
    ReelAuthor? author,
  }) = _Reel;

  bool get isPhoto => mediaType == 'image';

  factory Reel.fromJson(Map<String, dynamic> json) => _$ReelFromJson(json);
}

@freezed
class ReelAuthor with _$ReelAuthor {
  const factory ReelAuthor({
    required String id,
    String? displayName,  // nullable: user may not have set a name yet
    String? avatarUrl,
  }) = _ReelAuthor;

  factory ReelAuthor.fromJson(Map<String, dynamic> json) => _$ReelAuthorFromJson(json);
}
