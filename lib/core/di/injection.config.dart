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
import '../../features/auth/infrastructure/datasources/auth_datasource.dart'
    as _i696;
import '../../features/auth/infrastructure/repositories/auth_repository_impl.dart'
    as _i748;
import '../../features/auth/presentation/stores/auth_store.dart' as _i603;
import '../../features/auth/presentation/stores/interests_store.dart' as _i499;
import '../../features/home/data/repositories/discover_repository_impl.dart'
    as _i90;
import '../../features/home/domain/repositories/discover_repository.dart'
    as _i952;
import '../../features/home/domain/usecases/get_discover_batch_usecase.dart'
    as _i236;
import '../../features/home/domain/usecases/submit_swipe_usecase.dart' as _i219;
import '../../features/home/presentation/stores/discover_store.dart' as _i436;
import '../network/dio_client.dart' as _i667;
import '../network/network_info.dart' as _i932;
import '../services/image_upload_service.dart' as _i606;
import 'auth_module.dart' as _i784;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final authModule = _$AuthModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient());
    gh.lazySingleton<_i606.ImageUploadService>(
      () => _i606.ImageUploadService(),
    );
    gh.lazySingleton<_i932.NetworkInfo>(() => _i932.NetworkInfoImpl());
    gh.lazySingleton<_i696.AuthDatasource>(
      () => authModule.authDatasource(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i952.DiscoverRepository>(
      () => _i90.DiscoverRepositoryImpl(supabase: gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i236.GetDiscoverBatchUseCase>(
      () => _i236.GetDiscoverBatchUseCase(gh<_i952.DiscoverRepository>()),
    );
    gh.factory<_i219.SubmitSwipeUseCase>(
      () => _i219.SubmitSwipeUseCase(gh<_i952.DiscoverRepository>()),
    );
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
    gh.factory<_i436.DiscoverStore>(
      () => _i436.DiscoverStore(
        gh<_i236.GetDiscoverBatchUseCase>(),
        gh<_i219.SubmitSwipeUseCase>(),
      ),
    );
    gh.lazySingleton<_i603.AuthStore>(
      () => authModule.authStore(
        gh<_i696.AuthDatasource>(),
        gh<_i606.ImageUploadService>(),
      ),
    );
    gh.lazySingleton<_i499.InterestsStore>(
      () => authModule.interestsStore(
        gh<_i696.AuthDatasource>(),
        gh<_i603.AuthStore>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}

class _$AuthModule extends _i784.AuthModule {}
