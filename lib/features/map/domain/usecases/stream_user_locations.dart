import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location_entity.dart';
import '../repositories/i_map_social_repository.dart';

class StreamUserLocations
    implements StreamUseCase<List<LocationEntity>, Set<String>> {
  final IMapSocialRepository repository;

  StreamUserLocations(this.repository);

  @override
  Stream<Either<Failure, List<LocationEntity>>> call(Set<String> userIds) {
    return repository.streamUserLocations(userIds);
  }
}
