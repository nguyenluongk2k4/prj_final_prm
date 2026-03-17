import 'package:dartz/dartz.dart';
import 'package:prj_final_prm/core/errors/failures.dart';
import 'package:prj_final_prm/features/home/domain/entities/music.dart';
import 'package:prj_final_prm/features/home/domain/entities/reel.dart';

import '../entities/reel_comment.dart';

abstract class ReelsRepository {
  Future<Either<Failure, List<Reel>>> getReels({
    int offset = 0,
    int limit = 10,
    String? authorId,
    List<String>? friendIds,
  });
  Future<Either<Failure, void>> likeReel(String reelId);
  Future<Either<Failure, void>> unlikeReel(String reelId);
  Future<Either<Failure, Reel>> uploadReel({
    required String videoPath,
    required String description,
    String? thumbnailPath,
  });
  Future<Either<Failure, Reel>> uploadPhotoPost({
    required String imagePath,
    required String description,
    String? audioUrl,
  });
  Future<Either<Failure, List<ReelComment>>> getComments(String reelId);
  Future<Either<Failure, ReelComment>> postComment({
    required String reelId,
    required String content,
    String? parentId,
  });
  Future<Either<Failure, void>> deleteComment({
    required String commentId,
    required String reelId,
  });
  Future<Either<Failure, List<SystemMusic>>> getSystemMusic();
}
