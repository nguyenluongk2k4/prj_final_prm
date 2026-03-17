import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location_entity.dart';
import '../repositories/i_map_repository.dart';

class GetMatchLocations implements StreamUseCase<List<LocationEntity>, String> {
  final IMapRepository repository;

  GetMatchLocations(this.repository);

  @override
  Stream<Either<Failure, List<LocationEntity>>> call(String matchId) {
    return repository.getMatchLocations(matchId);
  }
}
