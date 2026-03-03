// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??= Computed<bool>(
    () => super.hasError,
    name: '_AuthStore.hasError',
  )).value;
  Computed<bool>? _$hasSuccessComputed;

  @override
  bool get hasSuccess => (_$hasSuccessComputed ??= Computed<bool>(
    () => super.hasSuccess,
    name: '_AuthStore.hasSuccess',
  )).value;

  late final _$currentUserAtom = Atom(
    name: '_AuthStore.currentUser',
    context: context,
  );

  @override
  UserModel? get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(UserModel? value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_AuthStore.isLoading',
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

  late final _$isAuthenticatedAtom = Atom(
    name: '_AuthStore.isAuthenticated',
    context: context,
  );

  @override
  bool get isAuthenticated {
    _$isAuthenticatedAtom.reportRead();
    return super.isAuthenticated;
  }

  @override
  set isAuthenticated(bool value) {
    _$isAuthenticatedAtom.reportWrite(value, super.isAuthenticated, () {
      super.isAuthenticated = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_AuthStore.errorMessage',
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

  late final _$successMessageAtom = Atom(
    name: '_AuthStore.successMessage',
    context: context,
  );

  @override
  String? get successMessage {
    _$successMessageAtom.reportRead();
    return super.successMessage;
  }

  @override
  set successMessage(String? value) {
    _$successMessageAtom.reportWrite(value, super.successMessage, () {
      super.successMessage = value;
    });
  }

  late final _$loginAsyncAction = AsyncAction(
    '_AuthStore.login',
    context: context,
  );

  @override
  Future<void> login({required String email, required String password}) {
    return _$loginAsyncAction.run(
      () => super.login(email: email, password: password),
    );
  }

  late final _$signupAsyncAction = AsyncAction(
    '_AuthStore.signup',
    context: context,
  );

  @override
  Future<void> signup({
    required String email,
    required String password,
    required String name,
    String? phone,
    List<String>? preferences,
    String? location,
  }) {
    return _$signupAsyncAction.run(
      () => super.signup(
        email: email,
        password: password,
        name: name,
        phone: phone,
        preferences: preferences,
        location: location,
      ),
    );
  }

  late final _$logoutAsyncAction = AsyncAction(
    '_AuthStore.logout',
    context: context,
  );

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$_AuthStoreActionController = ActionController(
    name: '_AuthStore',
    context: context,
  );

  @override
  void clearMessages() {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
      name: '_AuthStore.clearMessages',
    );
    try {
      return super.clearMessages();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentUser: ${currentUser},
isLoading: ${isLoading},
isAuthenticated: ${isAuthenticated},
errorMessage: ${errorMessage},
successMessage: ${successMessage},
hasError: ${hasError},
hasSuccess: ${hasSuccess}
    ''';
  }
}
