import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_map_repository.dart';

class UpdateLocation implements UseCase<void, UpdateLocationParams> {
  final IMapRepository repository;

  UpdateLocation(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateLocationParams params) async {
    return await repository.updateLocation(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class UpdateLocationParams {
  final double latitude;
  final double longitude;

  UpdateLocationParams({
    required this.latitude,
    required this.longitude,
  });
}
