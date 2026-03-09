import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/album_repository.dart';

import 'package:injectable/injectable.dart';

@injectable
class DeleteAlbumImageUseCase {
  final IAlbumRepository repository;

  DeleteAlbumImageUseCase(this.repository);

  Future<Either<Failure, void>> call(String imageId) async {
    return await repository.deleteAlbumImage(imageId);
  }
}
