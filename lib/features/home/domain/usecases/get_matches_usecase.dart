import '../entities/match_profile.dart';
import '../repositories/matches_repository.dart';

class GetMatchesUseCase {
  final MatchesRepository _repository;

  const GetMatchesUseCase(this._repository);

  Future<List<MatchProfile>> call() => _repository.getMatches();
}
