// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interests_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InterestsStore on _InterestsStore, Store {
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??= Computed<bool>(
    () => super.hasError,
    name: '_InterestsStore.hasError',
  )).value;

  late final _$isLoadingAtom = Atom(
    name: '_InterestsStore.isLoading',
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

  late final _$errorMessageAtom = Atom(
    name: '_InterestsStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$_loadLocalPreferencesAsyncAction = AsyncAction(
    '_InterestsStore._loadLocalPreferences',
    context: context,
  );

  @override
  Future<void> _loadLocalPreferences() {
    return _$_loadLocalPreferencesAsyncAction.run(
      () => super._loadLocalPreferences(),
    );
  }

  late final _$savePreferencesAsyncAction = AsyncAction(
    '_InterestsStore.savePreferences',
    context: context,
  );

  @override
  Future<void> savePreferences(List<String> preferences) {
    return _$savePreferencesAsyncAction.run(
      () => super.savePreferences(preferences),
    );
  }

  late final _$_InterestsStoreActionController = ActionController(
    name: '_InterestsStore',
    context: context,
  );

  @override
  void clearError() {
    final _$actionInfo = _$_InterestsStoreActionController.startAction(
      name: '_InterestsStore.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_InterestsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
errorMessage: ${errorMessage},
hasError: ${hasError}
    ''';
  }
}
