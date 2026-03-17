import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:prj_final_prm/features/auth/infrastructure/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/get_discover_batch_usecase.dart';
import '../../domain/usecases/submit_swipe_usecase.dart';
import '../../domain/usecases/undo_swipe_usecase.dart';
import '../../domain/usecases/check_match_usecase.dart';
import '../../domain/entities/swipe_type.dart' as domain;
import '../../domain/entities/discover_filter.dart';

part 'discover_store.g.dart';

abstract class _DiscoverStore with Store {
  final GetDiscoverBatchUseCase _getDiscoverBatch;
  final SubmitSwipeUseCase _submitSwipe;
  final UndoSwipeUseCase _undoSwipe;
  final CheckMatchUseCase _checkMatch;
  final SharedPreferences _prefs;

  static const String _filterKey = 'discover_filter';

  _DiscoverStore(
    this._getDiscoverBatch,
    this._submitSwipe,
    this._undoSwipe,
    this._checkMatch,
    this._prefs,
  ) {
    print('🏗️ DiscoverStore constructor called');
    print('🏗️ CheckMatchUseCase: ${_checkMatch.runtimeType}');
    _loadFilter();
  }

  @observable
  bool isLoading = false;

  @observable
  bool isSwipeInProgress = false;

  @observable
  String? error;

  @observable
  ObservableList<UserModel> profiles = ObservableList<UserModel>();

  @observable
  int _offset = 0;

  final int _limit = 10;

  @observable
  bool hasReachedEnd = false;

  @observable
  DiscoverFilter? currentFilter;

  // Track last swiped for undo
  @observable
  String? lastSwipedId;

  @observable
  domain.SwipeType? lastSwipeType;

  // Match notification callback
  @observable
  UserModel? newMatchUser;

  @action
  void _loadFilter() {
    final filterJson = _prefs.getString(_filterKey);
    if (filterJson != null) {
      try {
        currentFilter = DiscoverFilter.fromJsonString(filterJson);
      } catch (e) {
        // Ignore invalid filter
      }
    }
  }

  @action
  Future<void> setFilter(DiscoverFilter filter) async {
    currentFilter = filter;
    await _prefs.setString(_filterKey, filter.toJsonString());
    await fetchInitialBatch();
  }

  @action
  Future<void> clearFilter() async {
    currentFilter = null;
    await _prefs.remove(_filterKey);
    await fetchInitialBatch();
  }

  @action
  Future<void> fetchInitialBatch() async {
    isLoading = true;
    error = null;
    _offset = 0;
    profiles.clear();
    hasReachedEnd = false;

    final result = await _getDiscoverBatch.execute(
      limit: _limit,
      offset: _offset,
      filter: null, // Temporarily disable filter to test
    );

    result.fold(
      (l) => error = l,
      (r) {
        profiles.addAll(r);
        if (r.length < _limit) {
          hasReachedEnd = true;
        }
        _offset += r.length;
      },
    );

    isLoading = false;
  }

  @action
  Future<void> fetchNextBatch() async {
    if (isLoading || hasReachedEnd) return;

    isLoading = true;
    error = null;

    final result = await _getDiscoverBatch.execute(
      limit: _limit,
      offset: _offset,
      filter: null, // Temporarily disable filter to test
    );

    result.fold(
      (l) => error = l,
      (r) {
        if (r.isEmpty) {
          hasReachedEnd = true;
        } else {
          profiles.addAll(r);
          _offset += r.length;
          if (r.length < _limit) {
            hasReachedEnd = true;
          }
        }
      },
    );

    isLoading = false;
  }

  @action
  Future<void> onSwiped(UserModel profile, domain.SwipeType swipeType) async {
    print('🔄 onSwiped called: ${profile.name} with $swipeType');
    isSwipeInProgress = true;
    lastSwipedId = profile.id;
    lastSwipeType = swipeType;

    try {
      // Call API in background
      print('📤 Submitting swipe...');
      await _submitSwipe.execute(
        swipedId: profile.id,
        swipeType: swipeType,
      );
      print('✅ Swipe submitted successfully');

      // Check for match if it was a like or superlike
      if (swipeType == domain.SwipeType.like || swipeType == domain.SwipeType.superlike) {
        print('💕 Checking for match with ${profile.id}...');
        try {
          final hasMatch = await _checkMatch.execute(profile.id);
          print('💕 Match result: $hasMatch');
          if (hasMatch) {
            print('🎉 MATCH FOUND! Setting newMatchUser to ${profile.name}');
            newMatchUser = profile;
            print('🎯 newMatchUser set to: ${newMatchUser?.name}');
          } else {
            print('💔 No match found');
          }
        } catch (e) {
          print('❌ Error checking for match: $e');
        }
      } else {
        print('👎 Skipping match check for dislike');
      }
    } catch (e) {
      print('❌ Error in onSwiped: $e');
    } finally {
      isSwipeInProgress = false;
      print('🔄 onSwiped completed');
    }
  }

  @action
  void clearNewMatch() {
    newMatchUser = null;
  }

  @action
  Future<bool> undoLastSwipe() async {
    if (lastSwipedId == null) return false;

    isSwipeInProgress = true;

    final result = await _undoSwipe.execute(swipedId: lastSwipedId!);

    isSwipeInProgress = false;

    return result.fold(
      (l) {
        error = l;
        return false;
      },
      (_) {
        lastSwipedId = null;
        lastSwipeType = null;
        return true;
      },
    );
  }
}

@injectable
class DiscoverStore = _DiscoverStore with _$DiscoverStore;
