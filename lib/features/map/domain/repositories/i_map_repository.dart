import 'package:dartz/dartz.dart';
import 'package:prj_final_prm/core/errors/failures.dart';
import '../entities/location_entity.dart';

abstract class IMapRepository {
  Future<Either<Failure, void>> updateMatchLocation({
    required String matchId,
    required double latitude,
    required double longitude,
  });
  
  Stream<Either<Failure, List<LocationEntity>>> getMatchLocations(String matchId);

  Future<Either<Failure, List<LocationEntity>>> getNearbyUsers({
    required double radius,
  });

  Future<Either<Failure, LocationEntity>> getCurrentLocation();

  Future<Either<Failure, void>> updateLocation({
    required double latitude,
    required double longitude,
  });
}
