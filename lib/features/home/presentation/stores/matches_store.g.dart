// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matches_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MatchesStore on _MatchesStore, Store {
  late final _$isLoadingAtom = Atom(
    name: '_MatchesStore.isLoading',
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

  late final _$errorAtom = Atom(name: '_MatchesStore.error', context: context);

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

  late final _$matchesAtom = Atom(
    name: '_MatchesStore.matches',
    context: context,
  );

  @override
  ObservableList<Match> get matches {
    _$matchesAtom.reportRead();
    return super.matches;
  }

  @override
  set matches(ObservableList<Match> value) {
    _$matchesAtom.reportWrite(value, super.matches, () {
      super.matches = value;
    });
  }

  late final _$_offsetAtom = Atom(
    name: '_MatchesStore._offset',
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
    name: '_MatchesStore.hasReachedEnd',
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

  late final _$fetchInitialMatchesAsyncAction = AsyncAction(
    '_MatchesStore.fetchInitialMatches',
    context: context,
  );

  @override
  Future<void> fetchInitialMatches() {
    return _$fetchInitialMatchesAsyncAction.run(
      () => super.fetchInitialMatches(),
    );
  }

  late final _$fetchMoreMatchesAsyncAction = AsyncAction(
    '_MatchesStore.fetchMoreMatches',
    context: context,
  );

  @override
  Future<void> fetchMoreMatches() {
    return _$fetchMoreMatchesAsyncAction.run(() => super.fetchMoreMatches());
  }

  late final _$_MatchesStoreActionController = ActionController(
    name: '_MatchesStore',
    context: context,
  );

  @override
  void clearMatches() {
    final _$actionInfo = _$_MatchesStoreActionController.startAction(
      name: '_MatchesStore.clearMatches',
    );
    try {
      return super.clearMatches();
    } finally {
      _$_MatchesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
error: ${error},
matches: ${matches},
hasReachedEnd: ${hasReachedEnd}
    ''';
  }
}
