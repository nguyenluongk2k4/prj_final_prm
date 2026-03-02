import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/check_auth_usecase.dart';
import '../../domain/usecases/sign_in_phone_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';

part 'auth_store.g.dart';

@lazySingleton
class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final CheckAuthUseCase _checkAuthUseCase;
  final SignInWithPhoneUseCase _signInWithPhoneUseCase;
  final VerifyOtpAndSyncProfileUseCase _verifyOtpAndSyncUseCase;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  _AuthStore(
    this._checkAuthUseCase,
    this._signInWithPhoneUseCase,
    this._verifyOtpAndSyncUseCase,
    this._loginUseCase,
    this._logoutUseCase,
  );

  @observable
  bool isAuthenticated = false;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  String? verificationId;

  @observable
  UserProfile? currentUser;

  @action
  Future<void> checkAuthStatus() async {
    isLoading = true;
    isAuthenticated = await _checkAuthUseCase();
    isLoading = false;
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;

    final result = await _loginUseCase(LoginParams(email: email, password: password));

    result.fold(
      (Failure failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (UserProfile profile) {
        currentUser = profile;
        isAuthenticated = true;
        isLoading = false;
      },
    );
  }

  @action
  Future<void> logout() async {
    isLoading = true;
    final result = await _logoutUseCase(const NoParams());
    result.fold(
      (Failure failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (void _) {
        currentUser = null;
        isAuthenticated = false;
        isLoading = false;
      }
    );
  }

  @action
  Future<void> sendOtp(String phoneNumber) async {
    isLoading = true;
    errorMessage = null;

    final result = await _signInWithPhoneUseCase(phoneNumber);

    result.fold(
      (Failure failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (String vid) {
        verificationId = vid;
        isLoading = false;
      },
    );
  }

  @action
  Future<bool> verifyOtp(String smsCode, String phoneNumber) async {
    if (verificationId == null) {
      errorMessage = "Vui lòng đợi gửi lại mã OTP";
      return false;
    }

    isLoading = true;
    errorMessage = null;

    final result = await _verifyOtpAndSyncUseCase(verificationId!, smsCode, phoneNumber);

    return result.fold(
      (Failure failure) {
        errorMessage = failure.message;
        isLoading = false;
        return false;
      },
      (UserProfile profile) {
        currentUser = profile;
        isAuthenticated = true;
        isLoading = false;
        return true;
      },
    );
  }
}
