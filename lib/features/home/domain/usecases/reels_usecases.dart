import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/reel.dart';
import '../entities/reel_comment.dart';
import '../entities/music.dart';
import '../repositories/reels_repository.dart';

@injectable
class GetReelsUseCase {
  final ReelsRepository _repository;

  GetReelsUseCase(this._repository);

  Future<Either<Failure, List<Reel>>> execute({
    int offset = 0,
    int limit = 10,
    String? authorId,
    List<String>? friendIds,
  }) {
    return _repository.getReels(
      offset: offset,
      limit: limit,
      authorId: authorId,
      friendIds: friendIds,
    );
  }
}

@injectable
class LikeReelUseCase {
  final ReelsRepository _repository;

  LikeReelUseCase(this._repository);

  Future<Either<Failure, void>> execute(String reelId) {
    return _repository.likeReel(reelId);
  }
}

@injectable
class UnlikeReelUseCase {
  final ReelsRepository _repository;

  UnlikeReelUseCase(this._repository);

  Future<Either<Failure, void>> execute(String reelId) {
    return _repository.unlikeReel(reelId);
  }
}

@injectable
class UploadReelUseCase {
  final ReelsRepository _repository;

  UploadReelUseCase(this._repository);

  Future<Either<Failure, Reel>> execute({
    required String videoPath,
    required String description,
    String? thumbnailPath,
  }) {
    return _repository.uploadReel(
      videoPath: videoPath,
      description: description,
      thumbnailPath: thumbnailPath,
    );
  }
}

@injectable
class GetCommentsUseCase {
  final ReelsRepository _repository;
  GetCommentsUseCase(this._repository);

  Future<Either<Failure, List<ReelComment>>> execute(String reelId) {
    return _repository.getComments(reelId);
  }
}

@injectable
class PostCommentUseCase {
  final ReelsRepository _repository;
  PostCommentUseCase(this._repository);

  Future<Either<Failure, ReelComment>> execute({
    required String reelId,
    required String content,
    String? parentId,
  }) {
    return _repository.postComment(reelId: reelId, content: content, parentId: parentId);
  }
}

@injectable
class DeleteCommentUseCase {
  final ReelsRepository _repository;
  DeleteCommentUseCase(this._repository);

  Future<Either<Failure, void>> execute({
    required String commentId,
    required String reelId,
  }) {
    return _repository.deleteComment(commentId: commentId, reelId: reelId);
  }
}

@injectable
class UploadPhotoPostUseCase {
  final ReelsRepository _repository;
  UploadPhotoPostUseCase(this._repository);

  Future<Either<Failure, Reel>> execute({
    required String imagePath,
    required String description,
    String? audioUrl,
  }) {
    return _repository.uploadPhotoPost(
      imagePath: imagePath,
      description: description,
      audioUrl: audioUrl,
    );
  }
}

@injectable
class GetSystemMusicUseCase {
  final ReelsRepository _repository;
  GetSystemMusicUseCase(this._repository);

  Future<Either<Failure, List<SystemMusic>>> execute() {
    return _repository.getSystemMusic();
  }
}
