import 'dart:async';

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/map_profile_entity.dart';
import '../../domain/entities/match_info_entity.dart';
import '../../domain/repositories/i_map_social_repository.dart';
import '../datasources/map_social_remote_data_source.dart';
import '../models/location_model.dart';

class MapSocialRepositoryImpl implements IMapSocialRepository {
  final IMapSocialRemoteDataSource remoteDataSource;

  MapSocialRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Set<String>>> getFriendIds(String userId) async {
    try {
      final ids = await remoteDataSource.fetchFriendIds(userId);
      return Right(ids);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MatchInfoEntity>> getMatchInfo(String userId) async {
    try {
      final info = await remoteDataSource.fetchMatchInfo(userId);
      return Right(info);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MapProfileEntity>>> getProfiles({
    required Set<String> ids,
    required Set<String> friendIds,
    required Set<String> matchUserIds,
  }) async {
    try {
      final profiles = await remoteDataSource.fetchProfiles(
        ids: ids,
        friendIds: friendIds,
        matchUserIds: matchUserIds,
      );
      return Right(profiles);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<LocationEntity>>> streamUserLocations(
    Set<String> userIds,
  ) {
    return _wrapLocationStream(remoteDataSource.streamUserLocations(userIds));
  }

  @override
  Stream<Either<Failure, List<LocationEntity>>> streamMatchLocations(
    Set<String> matchIds,
  ) {
    return _wrapLocationStream(remoteDataSource.streamMatchLocations(matchIds));
  }

  Stream<Either<Failure, List<LocationEntity>>> _wrapLocationStream(
    Stream<List<LocationModel>> stream,
  ) {
    final controller =
        StreamController<Either<Failure, List<LocationEntity>>>();

    late final StreamSubscription<List<LocationModel>> sub;
    sub = stream.listen(
      (models) {
        controller.add(
          Right(models.map((model) => model.toEntity()).toList()),
        );
      },
      onError: (error, _) {
        controller.add(Left(ServerFailure(message: error.toString())));
      },
      onDone: controller.close,
    );

    controller.onCancel = () {
      sub.cancel();
      controller.close();
    };
    return controller.stream;
  }
}
