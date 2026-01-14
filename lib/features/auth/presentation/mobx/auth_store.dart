import 'package:mobx/mobx.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../../../core/usecases/usecase.dart';

part 'auth_store.g.dart';

/// MobX Store cho Auth
class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  _AuthStore({
    required this.loginUseCase,
    required this.logoutUseCase,
  });

  @observable
  User? user;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  bool isAuthenticated = false;

  @action
  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;

    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isAuthenticated = false;
      },
      (userData) {
        user = userData;
        isAuthenticated = true;
      },
    );

    isLoading = false;
  }

  @action
  Future<void> logout() async {
    isLoading = true;
    errorMessage = null;

    final result = await logoutUseCase(const NoParams());

    result.fold(
      (failure) {
        errorMessage = failure.message;
      },
      (_) {
        user = null;
        isAuthenticated = false;
      },
    );

    isLoading = false;
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}
