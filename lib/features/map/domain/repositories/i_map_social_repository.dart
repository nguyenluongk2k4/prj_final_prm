import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/location_entity.dart';
import '../entities/map_profile_entity.dart';
import '../entities/match_info_entity.dart';

abstract class IMapSocialRepository {
  Future<Either<Failure, Set<String>>> getFriendIds(String userId);
  Future<Either<Failure, MatchInfoEntity>> getMatchInfo(String userId);
  Future<Either<Failure, List<MapProfileEntity>>> getProfiles({
    required Set<String> ids,
    required Set<String> friendIds,
    required Set<String> matchUserIds,
  });
  Stream<Either<Failure, List<LocationEntity>>> streamUserLocations(
    Set<String> userIds,
  );
  Stream<Either<Failure, List<LocationEntity>>> streamMatchLocations(
    Set<String> matchIds,
  );
}
