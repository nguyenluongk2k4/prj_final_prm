import 'dart:async';

import 'dart:io';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;
import '../../infrastructure/datasources/datasources.dart';
import '../../infrastructure/models/models.dart';
import '../../../../core/services/image_upload_service.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final AuthDatasource authDatasource;
  final ImageUploadService imageUploadService;

  late StreamSubscription<AuthState> _authSubscription;

  _AuthStore({required this.authDatasource, required this.imageUploadService}) {
    _initAuthListener();
    fetchProvinces();
    // Startup session restore được xử lý trong main.dart trước runApp()
    // để đảm bảo isAuthenticated được set trước khi GoRouter khởi tạo
  }

  @observable
  UserModel? currentUser;

  @observable
  ObservableList<ProvinceModel> provinces = ObservableList<ProvinceModel>();

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
    _authSubscription = authDatasource.authStateChanges.listen((data) async {
      final session = data.session;
      isAuthenticated = session != null;
      if (session == null) {
        currentUser = null;
      } else {
        currentUser ??= await authDatasource.getCurrentUser();
      }
    });
  }

  @action
  Future<void> login({required String email, required String password}) async {
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
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    final response = await authDatasource.signup(
      email: email,
      password: password,
      name: name,
      phone: phone,
      latitude: null,
      longitude: null,
      preferences: preferences,
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
  void updatePreferences(List<String> preferences) {
    if (currentUser != null) {
      currentUser = currentUser!.copyWith(preferences: preferences);
    }
  }

  @action
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String bio,
    required DateTime? birthDate,
    required String? gender,
    required String? targetGender,
    required int? provinceId,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    final response = await authDatasource.updateProfile(
      name: name,
      phone: phone,
      bio: bio,
      birthDate: birthDate,
      gender: gender,
      targetGender: targetGender,
      provinceId: provinceId,
    );

    if (response.success) {
      currentUser = response.data;
      successMessage = 'Profile updated successfully';
    } else {
      errorMessage = response.errorMessage;
    }

    isLoading = false;
  }

  @action
  Future<void> updateBioAndProvince({
    required String bio,
    required int provinceId,
  }) async {
    isLoading = true;
    errorMessage = null;

    final response = await authDatasource.updateBioAndProvince(
      bio: bio,
      provinceId: provinceId,
    );

    if (response.success) {
      currentUser = response.data;
    } else {
      errorMessage = response.errorMessage;
    }

    isLoading = false;
  }

  @action
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    isLoading = true;
    errorMessage = null;

    final response = await authDatasource.updateLocation(
      latitude: latitude,
      longitude: longitude,
    );

    if (response.success) {
      currentUser = response.data;
    } else {
      errorMessage = response.errorMessage;
    }

    isLoading = false;
  }

  @action
  Future<void> uploadAvatar(File imageFile) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    final url = await imageUploadService.uploadImage(imageFile);

    if (url != null) {
      final response = await authDatasource.updateAvatar(url);
      if (response.success) {
        currentUser = response.data;
        successMessage = 'Avatar updated successfully';
      } else {
        errorMessage = response.errorMessage;
      }
    } else {
      errorMessage = 'Failed to upload image. Check configuration or network.';
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

  @action
  Future<void> fetchProvinces() async {
    try {
      final list = await authDatasource.getProvinces();
      provinces.clear();
      provinces.addAll(list);
    } catch (e) {
      errorMessage = 'Failed to fetch provinces: ${e.toString()}';
    }
  }

  void dispose() {
    _authSubscription.cancel();
  }
}
