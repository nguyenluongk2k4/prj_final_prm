import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/reel.dart';
import '../../domain/entities/music.dart';
import '../../domain/repositories/reels_repository.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/reels_datasource.dart';
import '../../domain/entities/reel_comment.dart';

@LazySingleton(as: ReelsRepository)
class ReelsRepositoryImpl implements ReelsRepository {
  final ReelsDatasource _datasource;

  ReelsRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<Reel>>> getReels({
    int offset = 0,
    int limit = 10,
    String? authorId,
    List<String>? friendIds,
  }) async {
    try {
      final list = await _datasource.getReels(
        offset: offset,
        limit: limit,
        authorId: authorId,
        friendIds: friendIds,
      );
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> likeReel(String reelId) async {
    try {
      await _datasource.likeReel(reelId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unlikeReel(String reelId) async {
    try {
      await _datasource.unlikeReel(reelId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Reel>> uploadReel({
    required String videoPath,
    required String description,
    String? thumbnailPath,
  }) async {
    try {
      final reel = await _datasource.uploadReel(
        videoPath: videoPath,
        description: description,
        thumbnailPath: thumbnailPath,
      );
      return Right(reel);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Reel>> uploadPhotoPost({
    required String imagePath,
    required String description,
    String? audioUrl,
  }) async {
    try {
      final reel = await _datasource.uploadPhotoPost(
        imagePath: imagePath,
        description: description,
        audioUrl: audioUrl,
      );
      return Right(reel);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReelComment>>> getComments(String reelId) async {
    try {
      final list = await _datasource.getComments(reelId);
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReelComment>> postComment({
    required String reelId,
    required String content,
    String? parentId,
  }) async {
    try {
      final comment = await _datasource.postComment(
        reelId: reelId,
        content: content,
        parentId: parentId,
      );
      return Right(comment);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment({
    required String commentId,
    required String reelId,
  }) async {
    try {
      await _datasource.deleteComment(commentId: commentId, reelId: reelId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SystemMusic>>> getSystemMusic() async {
    try {
      final list = await _datasource.getSystemMusic();
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
