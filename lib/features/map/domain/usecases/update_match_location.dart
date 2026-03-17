import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_map_repository.dart';

class UpdateMatchLocation implements UseCase<void, UpdateMatchLocationParams> {
  final IMapRepository repository;

  UpdateMatchLocation(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateMatchLocationParams params) async {
    return await repository.updateMatchLocation(
      matchId: params.matchId,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class UpdateMatchLocationParams {
  final String matchId;
  final double latitude;
  final double longitude;

  UpdateMatchLocationParams({
    required this.matchId,
    required this.latitude,
    required this.longitude,
  });
}
