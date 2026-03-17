import '../entities/match.dart';

abstract class MatchRepository {
  Future<List<Match>> getMatches({
    required int limit,
    required int offset,
  });
  
  Future<bool> checkForNewMatch(String swipedUserId);
}