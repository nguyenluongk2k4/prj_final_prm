import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/datasources/auth_datasource.dart';
import 'auth_store.dart';

part 'interests_store.g.dart';

class InterestsStore = _InterestsStore with _$InterestsStore;

abstract class _InterestsStore with Store {
  static const String _prefsKey = 'user_preferences';

  final AuthDatasource authDatasource;
  final AuthStore authStore;

  _InterestsStore({required this.authDatasource, required this.authStore}) {
    _loadLocalPreferences();
  }

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @computed
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  /// Load preferences từ SharedPreferences khi khởi động
  @action
  Future<void> _loadLocalPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_prefsKey);
    if (saved != null && authStore.currentUser != null) {
      authStore.updatePreferences(saved);
    }
  }

  /// Lưu preferences vào SharedPreferences + Supabase DB + cập nhật AuthStore
  @action
  Future<void> savePreferences(List<String> preferences) async {
    isLoading = true;
    errorMessage = null;

    try {
      // 1. Lưu local trước (nhanh, offline-safe)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_prefsKey, preferences);

      // 2. Lưu lên Supabase DB
      await authDatasource.savePreferences(preferences);

      // 3. Cập nhật currentUser trong AuthStore
      authStore.updatePreferences(preferences);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}
