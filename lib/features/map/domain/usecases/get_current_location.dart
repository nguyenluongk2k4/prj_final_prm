import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location_entity.dart';
import '../repositories/i_map_repository.dart';

class GetCurrentLocation implements UseCase<LocationEntity, NoParams> {
  final IMapRepository repository;

  GetCurrentLocation(this.repository);

  @override
  Future<Either<Failure, LocationEntity>> call(NoParams params) async {
    return await repository.getCurrentLocation();
  }
}
