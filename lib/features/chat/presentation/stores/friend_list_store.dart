import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import '../../domain/entities/friend_profile.dart';
import '../../domain/usecases/get_friends_usecase.dart';
import '../../domain/usecases/subscribe_friends_realtime_usecase.dart';

part 'friend_list_store.g.dart';

@injectable
class FriendListStore = _FriendListStore with _$FriendListStore;

abstract class _FriendListStore with Store {
  final GetFriendsUseCase _getFriendsUseCase;
  final SubscribeFriendsRealtimeUseCase _subscribeFriendsRealtimeUseCase;

  StreamSubscription<void>? _friendsSub;

  _FriendListStore(this._getFriendsUseCase, this._subscribeFriendsRealtimeUseCase);

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @observable
  ObservableList<FriendProfile> friends = ObservableList<FriendProfile>();

  @action
  Future<void> fetchFriends() async {
    isLoading = true;
    error = null;

    final result = await _getFriendsUseCase.execute();

    result.fold(
      (l) => error = l,
      (r) {
        friends.clear();
        friends.addAll(r);
      },
    );

    isLoading = false;
  }

  @action
  void startRealtime(String myId) {
    _friendsSub?.cancel();
    _friendsSub = _subscribeFriendsRealtimeUseCase
        .execute(myId: myId)
        .listen((_) => fetchFriends());
  }

  @action
  Future<void> stopRealtime() async {
    await _friendsSub?.cancel();
    _friendsSub = null;
  }
}
