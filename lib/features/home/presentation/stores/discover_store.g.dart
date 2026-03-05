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

  late final _$_DiscoverStoreActionController = ActionController(
    name: '_DiscoverStore',
    context: context,
  );

  @override
  void onSwiped(UserModel profile, bool isLike) {
    final _$actionInfo = _$_DiscoverStoreActionController.startAction(
      name: '_DiscoverStore.onSwiped',
    );
    try {
      return super.onSwiped(profile, isLike);
    } finally {
      _$_DiscoverStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
error: ${error},
profiles: ${profiles},
hasReachedEnd: ${hasReachedEnd}
    ''';
  }
}
