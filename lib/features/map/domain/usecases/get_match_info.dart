import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/match_info_entity.dart';
import '../repositories/i_map_social_repository.dart';

class GetMatchInfo implements UseCase<MatchInfoEntity, String> {
  final IMapSocialRepository repository;

  GetMatchInfo(this.repository);

  @override
  Future<Either<Failure, MatchInfoEntity>> call(String userId) {
    return repository.getMatchInfo(userId);
  }
}
