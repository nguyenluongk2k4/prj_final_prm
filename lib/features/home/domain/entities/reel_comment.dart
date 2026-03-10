import 'package:freezed_annotation/freezed_annotation.dart';
import 'reel.dart';

part 'reel_comment.freezed.dart';
part 'reel_comment.g.dart';

@freezed
class ReelComment with _$ReelComment {
  const factory ReelComment({
    required String id,
    required String reelId,
    required String userId,
    required String content,
    required DateTime createdAt,
    ReelAuthor? user,
  }) = _ReelComment;

  factory ReelComment.fromJson(Map<String, dynamic> json) => _$ReelCommentFromJson(json);
}
