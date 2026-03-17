import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_map_social_repository.dart';

class GetFriendIds implements UseCase<Set<String>, String> {
  final IMapSocialRepository repository;

  GetFriendIds(this.repository);

  @override
  Future<Either<Failure, Set<String>>> call(String userId) {
    return repository.getFriendIds(userId);
  }
}
