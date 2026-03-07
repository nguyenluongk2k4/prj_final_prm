import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:prj_final_prm/features/auth/infrastructure/models/user_model.dart';
import '../../domain/usecases/get_discover_batch_usecase.dart';
import '../../domain/usecases/submit_swipe_usecase.dart';

part 'discover_store.g.dart';

@injectable
class DiscoverStore = _DiscoverStore with _$DiscoverStore;

abstract class _DiscoverStore with Store {
  final GetDiscoverBatchUseCase _getDiscoverBatch;
  final SubmitSwipeUseCase _submitSwipe;

  _DiscoverStore(this._getDiscoverBatch, this._submitSwipe);

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @observable
  ObservableList<UserModel> profiles = ObservableList<UserModel>();

  @observable
  int _offset = 0;
  
  final int _limit = 10;
  
  @observable
  bool hasReachedEnd = false;

  @action
  Future<void> fetchInitialBatch() async {
    isLoading = true;
    error = null;
    _offset = 0;
    profiles.clear();
    hasReachedEnd = false;

    final result = await _getDiscoverBatch.execute(limit: _limit, offset: _offset);

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

    final result = await _getDiscoverBatch.execute(limit: _limit, offset: _offset);

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
  void onSwiped(UserModel profile, bool isLike) {
    // Call API in background
    _submitSwipe.execute(swipedId: profile.id, isLike: isLike);
  }
}
