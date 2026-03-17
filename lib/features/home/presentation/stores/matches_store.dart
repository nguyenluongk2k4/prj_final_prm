import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import '../../domain/entities/match.dart';
import '../../domain/usecases/get_matches_usecase.dart';

part 'matches_store.g.dart';

@injectable
class MatchesStore = _MatchesStore with _$MatchesStore;

abstract class _MatchesStore with Store {
  final GetMatchesUseCase _getMatchesUseCase;

  _MatchesStore(this._getMatchesUseCase);

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @observable
  ObservableList<Match> matches = ObservableList<Match>();

  @observable
  int _offset = 0;

  final int _limit = 20;

  @observable
  bool hasReachedEnd = false;

  @action
  Future<void> fetchInitialMatches() async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    _offset = 0;
    hasReachedEnd = false;

    try {
      final newMatches = await _getMatchesUseCase.execute(
        limit: _limit,
        offset: _offset,
      );

      matches.clear();
      matches.addAll(newMatches);

      if (newMatches.length < _limit) {
        hasReachedEnd = true;
      } else {
        _offset += _limit;
      }
    } catch (e) {
      error = e.toString();
      print('❌ Error fetching matches: $e');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> fetchMoreMatches() async {
    if (isLoading || hasReachedEnd) return;

    isLoading = true;
    error = null;

    try {
      final newMatches = await _getMatchesUseCase.execute(
        limit: _limit,
        offset: _offset,
      );

      matches.addAll(newMatches);

      if (newMatches.length < _limit) {
        hasReachedEnd = true;
      } else {
        _offset += _limit;
      }
    } catch (e) {
      error = e.toString();
      print('❌ Error fetching more matches: $e');
    } finally {
      isLoading = false;
    }
  }

  @action
  void clearMatches() {
    matches.clear();
    _offset = 0;
    hasReachedEnd = false;
    error = null;
  }
}