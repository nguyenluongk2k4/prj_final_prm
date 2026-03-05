import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/discover_repository.dart';

@injectable
class SubmitSwipeUseCase {
  final DiscoverRepository _repository;

  SubmitSwipeUseCase(this._repository);

  Future<Either<String, void>> execute({
    required String swipedId,
    required bool isLike,
  }) async {
    try {
      await _repository.submitSwipe(
        swipedId: swipedId,
        isLike: isLike,
      );
      return const Right(null);
    } catch (e) {
      return Left('Failed to submit swipe: ${e.toString()}');
    }
  }
}
