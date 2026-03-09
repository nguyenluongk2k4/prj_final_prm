import 'package:dartz/dartz.dart';
import 'dart:io';
import '../../../../core/errors/failures.dart';
import '../entities/album_image.dart';

abstract class IAlbumRepository {
  Future<Either<Failure, List<AlbumImage>>> getMyAlbumImages();
  Future<Either<Failure, List<AlbumImage>>> getUserAlbumImages(String userId);
  Future<Either<Failure, AlbumImage>> uploadAlbumImage(File imageFile);
  Future<Either<Failure, void>> deleteAlbumImage(String imageId);
}
