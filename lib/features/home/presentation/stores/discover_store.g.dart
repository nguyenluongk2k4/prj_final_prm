// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DiscoverStore on _DiscoverStore, Store {
  late final _$isLoadingAtom = Atom(
    name: '_DiscoverStore.isLoading',
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

  late final _$isSwipeInProgressAtom = Atom(
    name: '_DiscoverStore.isSwipeInProgress',
    context: context,
  );

  @override
  bool get isSwipeInProgress {
    _$isSwipeInProgressAtom.reportRead();
    return super.isSwipeInProgress;
  }

  @override
  set isSwipeInProgress(bool value) {
    _$isSwipeInProgressAtom.reportWrite(value, super.isSwipeInProgress, () {
      super.isSwipeInProgress = value;
    });
  }

  late final _$errorAtom = Atom(name: '_DiscoverStore.error', context: context);

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

  late final _$profilesAtom = Atom(
    name: '_DiscoverStore.profiles',
    context: context,
  );

  @override
  ObservableList<UserModel> get profiles {
    _$profilesAtom.reportRead();
    return super.profiles;
  }

  @override
  set profiles(ObservableList<UserModel> value) {
    _$profilesAtom.reportWrite(value, super.profiles, () {
      super.profiles = value;
    });
  }

  late final _$_offsetAtom = Atom(
    name: '_DiscoverStore._offset',
    context: context,
  );

  @override
  int get _offset {
    _$_offsetAtom.reportRead();
    return super._offset;
  }

  @override
  set _offset(int value) {
    _$_offsetAtom.reportWrite(value, super._offset, () {
      super._offset = value;
    });
  }

  late final _$hasReachedEndAtom = Atom(
    name: '_DiscoverStore.hasReachedEnd',
    context: context,
  );

  @override
  bool get hasReachedEnd {
    _$hasReachedEndAtom.reportRead();
    return super.hasReachedEnd;
  }

  @override
  set hasReachedEnd(bool value) {
    _$hasReachedEndAtom.reportWrite(value, super.hasReachedEnd, () {
      super.hasReachedEnd = value;
    });
  }

  late final _$currentFilterAtom = Atom(
    name: '_DiscoverStore.currentFilter',
    context: context,
  );

  @override
  DiscoverFilter? get currentFilter {
    _$currentFilterAtom.reportRead();
    return super.currentFilter;
  }

  @override
  set currentFilter(DiscoverFilter? value) {
    _$currentFilterAtom.reportWrite(value, super.currentFilter, () {
      super.currentFilter = value;
    });
  }

  late final _$lastSwipedIdAtom = Atom(
    name: '_DiscoverStore.lastSwipedId',
    context: context,
  );

  @override
  String? get lastSwipedId {
    _$lastSwipedIdAtom.reportRead();
    return super.lastSwipedId;
  }

  @override
  set lastSwipedId(String? value) {
    _$lastSwipedIdAtom.reportWrite(value, super.lastSwipedId, () {
      super.lastSwipedId = value;
    });
  }

  late final _$lastSwipeTypeAtom = Atom(
    name: '_DiscoverStore.lastSwipeType',
    context: context,
  );

  @override
  domain.SwipeType? get lastSwipeType {
    _$lastSwipeTypeAtom.reportRead();
    return super.lastSwipeType;
  }

  @override
  set lastSwipeType(domain.SwipeType? value) {
    _$lastSwipeTypeAtom.reportWrite(value, super.lastSwipeType, () {
      super.lastSwipeType = value;
    });
  }

  late final _$newMatchUserAtom = Atom(
    name: '_DiscoverStore.newMatchUser',
    context: context,
  );

  @override
  UserModel? get newMatchUser {
    _$newMatchUserAtom.reportRead();
    return super.newMatchUser;
  }

  @override
  set newMatchUser(UserModel? value) {
    _$newMatchUserAtom.reportWrite(value, super.newMatchUser, () {
      super.newMatchUser = value;
    });
  }

  late final _$setFilterAsyncAction = AsyncAction(
    '_DiscoverStore.setFilter',
    context: context,
  );

  @override
  Future<void> setFilter(DiscoverFilter filter) {
    return _$setFilterAsyncAction.run(() => super.setFilter(filter));
  }

  late final _$clearFilterAsyncAction = AsyncAction(
    '_DiscoverStore.clearFilter',
    context: context,
  );

  @override
  Future<void> clearFilter() {
    return _$clearFilterAsyncAction.run(() => super.clearFilter());
  }

  late final _$fetchInitialBatchAsyncAction = AsyncAction(
    '_DiscoverStore.fetchInitialBatch',
    context: context,
  );

  @override
  Future<void> fetchInitialBatch() {
    return _$fetchInitialBatchAsyncAction.run(() => super.fetchInitialBatch());
  }

  late final _$fetchNextBatchAsyncAction = AsyncAction(
    '_DiscoverStore.fetchNextBatch',
    context: context,
  );

  @override
  Future<void> fetchNextBatch() {
    return _$fetchNextBatchAsyncAction.run(() => super.fetchNextBatch());
  }

  late final _$onSwipedAsyncAction = AsyncAction(
    '_DiscoverStore.onSwiped',
    context: context,
  );

  @override
  Future<void> onSwiped(UserModel profile, domain.SwipeType swipeType) {
    return _$onSwipedAsyncAction.run(() => super.onSwiped(profile, swipeType));
  }

  late final _$undoLastSwipeAsyncAction = AsyncAction(
    '_DiscoverStore.undoLastSwipe',
    context: context,
  );

  @override
  Future<bool> undoLastSwipe() {
    return _$undoLastSwipeAsyncAction.run(() => super.undoLastSwipe());
  }

  late final _$_DiscoverStoreActionController = ActionController(
    name: '_DiscoverStore',
    context: context,
  );

  @override
  void _loadFilter() {
    final _$actionInfo = _$_DiscoverStoreActionController.startAction(
      name: '_DiscoverStore._loadFilter',
    );
    try {
      return super._loadFilter();
    } finally {
      _$_DiscoverStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearNewMatch() {
    final _$actionInfo = _$_DiscoverStoreActionController.startAction(
      name: '_DiscoverStore.clearNewMatch',
    );
    try {
      return super.clearNewMatch();
    } finally {
      _$_DiscoverStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isSwipeInProgress: ${isSwipeInProgress},
error: ${error},
profiles: ${profiles},
hasReachedEnd: ${hasReachedEnd},
currentFilter: ${currentFilter},
lastSwipedId: ${lastSwipedId},
lastSwipeType: ${lastSwipeType},
newMatchUser: ${newMatchUser}
    ''';
  }
}
