import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:prj_final_prm/features/auth/infrastructure/models/user_model.dart';
import '../repositories/discover_repository.dart';

@injectable
class GetDiscoverBatchUseCase {
  final DiscoverRepository _repository;

  GetDiscoverBatchUseCase(this._repository);

  Future<Either<String, List<UserModel>>> execute({
    required int limit,
    required int offset,
  }) async {
    try {
      final profiles = await _repository.getDiscoverProfiles(
        limit: limit,
        offset: offset,
      );
      return Right(profiles);
    } catch (e) {
      return Left('Failed to fetch discover profiles: ${e.toString()}');
    }
  }
}
