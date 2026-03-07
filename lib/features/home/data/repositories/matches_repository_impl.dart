import '../../infrastructure/datasources/matches_datasource.dart';
import '../../domain/entities/match_profile.dart';
import '../../domain/repositories/matches_repository.dart';

class MatchesRepositoryImpl implements MatchesRepository {
  final MatchesDatasource _datasource;

  MatchesRepositoryImpl(this._datasource);

  @override
  Future<List<MatchProfile>> getMatches() async {
    return await _datasource.getMatches();
  }
}
