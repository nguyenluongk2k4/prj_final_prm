import 'package:injectable/injectable.dart';
import '../entities/match.dart';
import '../repositories/match_repository.dart';

@injectable
class GetMatchesUseCase {
  final MatchRepository _repository;

  GetMatchesUseCase(this._repository);

  Future<List<Match>> execute({
    required int limit,
    required int offset,
  }) async {
    return await _repository.getMatches(
      limit: limit,
      offset: offset,
    );
  }
}