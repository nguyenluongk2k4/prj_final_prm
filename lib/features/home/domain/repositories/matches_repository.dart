import '../entities/match_profile.dart';

abstract class MatchesRepository {
  Future<List<MatchProfile>> getMatches();
}
