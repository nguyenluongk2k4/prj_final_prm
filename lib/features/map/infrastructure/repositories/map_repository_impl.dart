import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/i_map_repository.dart';
import '../datasources/map_remote_data_source.dart';
import '../models/location_model.dart';

class MapRepositoryImpl implements IMapRepository {
  final IMapRemoteDataSource remoteDataSource;

  MapRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> updateMatchLocation({
    required String matchId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await remoteDataSource.updateMatchLocation(
        matchId: matchId,
        latitude: latitude,
        longitude: longitude,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<LocationEntity>>> getMatchLocations(String matchId) {
    return remoteDataSource.getMatchLocations(matchId).map(
      (list) => Right<Failure, List<LocationEntity>>(
        list.map((model) => model.toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    try {
      final locationModel = await remoteDataSource.getCurrentLocation();
      return Right(locationModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LocationEntity>>> getNearbyUsers({
    required double radius,
  }) async {
    try {
      final users = await remoteDataSource.getNearbyUsers(radius: radius);
      return Right(users.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      await remoteDataSource.updateLocation(
        latitude: latitude,
        longitude: longitude,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
