import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location_entity.dart';
import '../repositories/i_map_repository.dart';

class GetNearbyUsers implements UseCase<List<LocationEntity>, double> {
  final IMapRepository repository;

  GetNearbyUsers(this.repository);

  @override
  Future<Either<Failure, List<LocationEntity>>> call(double radius) async {
    return await repository.getNearbyUsers(radius: radius);
  }
}
