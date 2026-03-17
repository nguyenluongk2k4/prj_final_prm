import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location_entity.dart';
import '../repositories/i_map_social_repository.dart';

class StreamMatchLocations
    implements StreamUseCase<List<LocationEntity>, Set<String>> {
  final IMapSocialRepository repository;

  StreamMatchLocations(this.repository);

  @override
  Stream<Either<Failure, List<LocationEntity>>> call(Set<String> matchIds) {
    return repository.streamMatchLocations(matchIds);
  }
}
