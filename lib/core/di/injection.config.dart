// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/check_auth_usecase.dart' as _i831;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/sign_in_phone_usecase.dart'
    as _i256;
import '../../features/auth/domain/usecases/verify_otp_usecase.dart' as _i503;
import '../../features/auth/infrastructure/repositories/auth_repository_impl.dart'
    as _i748;
import '../../features/auth/presentation/store/auth_store.dart' as _i172;
import '../network/dio_client.dart' as _i667;
import '../network/network_info.dart' as _i932;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient());
    gh.lazySingleton<_i932.NetworkInfo>(() => _i932.NetworkInfoImpl());
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i748.AuthRepositoryImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.lazySingleton<_i831.CheckAuthUseCase>(
      () => _i831.CheckAuthUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i48.LogoutUseCase>(
      () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i256.SignInWithPhoneUseCase>(
      () => _i256.SignInWithPhoneUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i503.VerifyOtpAndSyncProfileUseCase>(
      () => _i503.VerifyOtpAndSyncProfileUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i172.AuthStore>(
      () => _i172.AuthStore(
        gh<_i831.CheckAuthUseCase>(),
        gh<_i256.SignInWithPhoneUseCase>(),
        gh<_i503.VerifyOtpAndSyncProfileUseCase>(),
        gh<_i188.LoginUseCase>(),
        gh<_i48.LogoutUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
