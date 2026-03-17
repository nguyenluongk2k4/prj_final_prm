import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/map_profile_entity.dart';
import '../repositories/i_map_social_repository.dart';

class GetMapProfilesParams {
  final Set<String> ids;
  final Set<String> friendIds;
  final Set<String> matchUserIds;

  const GetMapProfilesParams({
    required this.ids,
    required this.friendIds,
    required this.matchUserIds,
  });
}

class GetMapProfiles
    implements UseCase<List<MapProfileEntity>, GetMapProfilesParams> {
  final IMapSocialRepository repository;

  GetMapProfiles(this.repository);

  @override
  Future<Either<Failure, List<MapProfileEntity>>> call(
    GetMapProfilesParams params,
  ) {
    return repository.getProfiles(
      ids: params.ids,
      friendIds: params.friendIds,
      matchUserIds: params.matchUserIds,
    );
  }
}
