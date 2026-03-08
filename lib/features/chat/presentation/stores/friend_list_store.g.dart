// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FriendListStore on _FriendListStore, Store {
  late final _$isLoadingAtom = Atom(
    name: '_FriendListStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorAtom = Atom(
    name: '_FriendListStore.error',
    context: context,
  );

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$friendsAtom = Atom(
    name: '_FriendListStore.friends',
    context: context,
  );

  @override
  ObservableList<FriendProfile> get friends {
    _$friendsAtom.reportRead();
    return super.friends;
  }

  @override
  set friends(ObservableList<FriendProfile> value) {
    _$friendsAtom.reportWrite(value, super.friends, () {
      super.friends = value;
    });
  }

  late final _$fetchFriendsAsyncAction = AsyncAction(
    '_FriendListStore.fetchFriends',
    context: context,
  );

  @override
  Future<void> fetchFriends() {
    return _$fetchFriendsAsyncAction.run(() => super.fetchFriends());
  }

  late final _$stopRealtimeAsyncAction = AsyncAction(
    '_FriendListStore.stopRealtime',
    context: context,
  );

  @override
  Future<void> stopRealtime() {
    return _$stopRealtimeAsyncAction.run(() => super.stopRealtime());
  }

  late final _$_FriendListStoreActionController = ActionController(
    name: '_FriendListStore',
    context: context,
  );

  @override
  void startRealtime(String myId) {
    final _$actionInfo = _$_FriendListStoreActionController.startAction(
      name: '_FriendListStore.startRealtime',
    );
    try {
      return super.startRealtime(myId);
    } finally {
      _$_FriendListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
error: ${error},
friends: ${friends}
    ''';
  }
}
