import '../../domain/entities/match_profile.dart';
import '../../domain/repositories/matches_repository.dart';

/// Stub repository — replace with real API calls as needed
class MatchesRepositoryImpl implements MatchesRepository {
  static final _now = DateTime.now();
  static final _yesterday = _now.subtract(const Duration(days: 1));

  static final List<MatchProfile> _todayMatches = [
    MatchProfile(
      id: '1',
      name: 'Leilani',
      age: 19,
      imagePath: 'assets/images/match_leilani.png',
      matchedAt: _now,
    ),
    MatchProfile(
      id: '2',
      name: 'Annabelle',
      age: 20,
      imagePath: 'assets/images/match_annabelle.png',
      matchedAt: _now,
    ),
    MatchProfile(
      id: '3',
      name: 'Reagan',
      age: 24,
      imagePath: 'assets/images/match_reagan.png',
      matchedAt: _now,
    ),
    MatchProfile(
      id: '4',
      name: 'Hadley',
      age: 25,
      imagePath: 'assets/images/match_hadley.png',
      matchedAt: _now,
    ),
  ];

  static final List<MatchProfile> _yesterdayMatches = [
    MatchProfile(
      id: '5',
      name: 'Kyle',
      age: 24,
      imagePath: 'assets/images/match_kyle1.png',
      matchedAt: _yesterday,
    ),
    MatchProfile(
      id: '6',
      name: 'Kyle',
      age: 24,
      imagePath: 'assets/images/match_kyle2.png',
      matchedAt: _yesterday,
    ),
  ];

  @override
  Future<List<MatchProfile>> getMatches() async {
    return [..._todayMatches, ..._yesterdayMatches];
  }
}
