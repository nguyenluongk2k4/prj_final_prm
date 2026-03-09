import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/album_image.dart';
import '../repositories/album_repository.dart';

import 'package:injectable/injectable.dart';

@injectable
class UploadAlbumImageUseCase {
  final IAlbumRepository repository;

  UploadAlbumImageUseCase(this.repository);

  Future<Either<Failure, AlbumImage>> call(File imageFile) async {
    return await repository.uploadAlbumImage(imageFile);
  }
}
