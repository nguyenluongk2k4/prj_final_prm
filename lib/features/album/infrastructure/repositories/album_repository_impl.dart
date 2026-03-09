import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/album_image.dart';
import '../../domain/repositories/album_repository.dart';
import '../datasources/album_remote_datasource.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IAlbumRepository)
class AlbumRepositoryImpl implements IAlbumRepository {
  final AlbumRemoteDataSource remoteDataSource;

  AlbumRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AlbumImage>>> getMyAlbumImages() async {
    try {
      final userId = remoteDataSource.supabase.auth.currentUser?.id;
      if (userId == null) return const Right([]);
      return getUserAlbumImages(userId);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AlbumImage>>> getUserAlbumImages(String userId) async {
    try {
      final models = await remoteDataSource.getUserAlbumImages(userId);
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AlbumImage>> uploadAlbumImage(File imageFile) async {
    try {
      final model = await remoteDataSource.uploadAlbumImage(imageFile);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAlbumImage(String imageId) async {
    try {
      await remoteDataSource.deleteAlbumImage(imageId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
