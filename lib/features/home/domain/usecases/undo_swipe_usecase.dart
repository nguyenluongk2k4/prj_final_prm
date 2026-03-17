import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/discover_repository.dart';

@injectable
class UndoSwipeUseCase {
  final DiscoverRepository _repository;

  UndoSwipeUseCase(this._repository);

  Future<Either<String, void>> execute({
    required String swipedId,
  }) async {
    try {
      await _repository.undoSwipe(swipedId: swipedId);
      return const Right(null);
    } catch (e) {
      return Left('Failed to undo swipe: ${e.toString()}');
    }
  }
}
