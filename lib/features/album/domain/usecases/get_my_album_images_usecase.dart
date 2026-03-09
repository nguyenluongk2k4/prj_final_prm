import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/album_image.dart';
import '../repositories/album_repository.dart';

import 'package:injectable/injectable.dart';

@injectable
class GetMyAlbumImagesUseCase {
  final IAlbumRepository repository;

  GetMyAlbumImagesUseCase(this.repository);

  Future<Either<Failure, List<AlbumImage>>> call() async {
    return await repository.getMyAlbumImages();
  }
}
