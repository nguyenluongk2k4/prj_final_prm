import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;
import '../../infrastructure/datasources/datasources.dart';
import '../../infrastructure/models/models.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final AuthDatasource authDatasource;

  late StreamSubscription<AuthState> _authSubscription;

  _AuthStore({required this.authDatasource}) {
    _initAuthListener();
    _restoreSession();
  }

  @observable
  UserModel? currentUser;

  @observable
  bool isLoading = false;

  @observable
  bool isAuthenticated = false;

  @observable
  String? errorMessage;

  @observable
  String? successMessage;

  @computed
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  @computed
  bool get hasSuccess => successMessage != null && successMessage!.isNotEmpty;

  /// Initialize auth state listener
  void _initAuthListener() {
    _authSubscription = authDatasource.authStateChanges.listen((data) {
      final session = data.session;
      isAuthenticated = session != null;
      if (session == null) {
        currentUser = null;
      }
    });
  }

  /// Restore session on app restart
  Future<void> _restoreSession() async {
    try {
      final session = authDatasource.getCurrentSession();
      if (session != null) {
        final user = await authDatasource.getCurrentUser();
        currentUser = user;
        isAuthenticated = true;
      }
    } catch (e) {
      print('Error restoring session: $e');
    }
  }

  @action
  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    final response = await authDatasource.login(
      email: email,
      password: password,
    );

    if (response.success) {
      currentUser = response.data;
      isAuthenticated = true;
      successMessage = 'Login successful';
    } else {
      errorMessage = response.errorMessage;
      isAuthenticated = false;
    }

    isLoading = false;
  }

  @action
  Future<void> signup({
    required String email,
    required String password,
    required String name,
    String? phone,
    List<String>? preferences,
    String? location,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    final response = await authDatasource.signup(
      email: email,
      password: password,
      name: name,
      phone: phone,
      preferences: preferences,
      location: location,
    );

    if (response.success) {
      currentUser = response.data;
      isAuthenticated = true;
      successMessage = 'Signup successful';
    } else {
      errorMessage = response.errorMessage;
      isAuthenticated = false;
    }

    isLoading = false;
  }

  @action
  Future<void> logout() async {
    isLoading = true;
    errorMessage = null;

    try {
      await authDatasource.logout();
      currentUser = null;
      isAuthenticated = false;
      successMessage = 'Logout successful';
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
  }

  @action
  void clearMessages() {
    errorMessage = null;
    successMessage = null;
  }

  void dispose() {
    _authSubscription.cancel();
  }
}
