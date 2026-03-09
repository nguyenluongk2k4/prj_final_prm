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

import '../../features/album/domain/repositories/album_repository.dart'
    as _i544;
import '../../features/album/domain/usecases/delete_album_image_usecase.dart'
    as _i593;
import '../../features/album/domain/usecases/get_my_album_images_usecase.dart'
    as _i908;
import '../../features/album/domain/usecases/upload_album_image_usecase.dart'
    as _i379;
import '../../features/album/infrastructure/datasources/album_remote_datasource.dart'
    as _i389;
import '../../features/album/infrastructure/repositories/album_repository_impl.dart'
    as _i13;
import '../../features/album/presentation/stores/album_store.dart' as _i964;
import '../../features/auth/data/repositories/presence_repository_impl.dart'
    as _i513;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/repositories/presence_repository.dart'
    as _i850;
import '../../features/auth/domain/usecases/check_auth_usecase.dart' as _i831;
import '../../features/auth/domain/usecases/get_user_profile_usecase.dart'
    as _i82;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/set_offline_usecase.dart' as _i655;
import '../../features/auth/domain/usecases/sign_in_phone_usecase.dart'
    as _i256;
import '../../features/auth/domain/usecases/update_presence_usecase.dart'
    as _i700;
import '../../features/auth/domain/usecases/verify_otp_usecase.dart' as _i503;
import '../../features/auth/infrastructure/datasources/auth_datasource.dart'
    as _i696;
import '../../features/auth/infrastructure/datasources/presence_datasource.dart'
    as _i307;
import '../../features/auth/infrastructure/repositories/auth_repository_impl.dart'
    as _i748;
import '../../features/auth/presentation/stores/auth_store.dart' as _i603;
import '../../features/auth/presentation/stores/interests_store.dart' as _i499;
import '../../features/auth/presentation/stores/presence_store.dart' as _i378;
import '../../features/chat/data/repositories/chat_media_repository_impl.dart'
    as _i785;
import '../../features/chat/data/repositories/chat_repository_impl.dart'
    as _i504;
import '../../features/chat/data/repositories/friends_repository_impl.dart'
    as _i189;
import '../../features/chat/data/repositories/typing_repository_impl.dart'
    as _i706;
import '../../features/chat/domain/repositories/chat_media_repository.dart'
    as _i122;
import '../../features/chat/domain/repositories/chat_repository.dart' as _i420;
import '../../features/chat/domain/repositories/friends_repository.dart'
    as _i473;
import '../../features/chat/domain/repositories/typing_repository.dart'
    as _i185;
import '../../features/chat/domain/usecases/check_friendship_usecase.dart'
    as _i354;
import '../../features/chat/domain/usecases/create_typing_channel_usecase.dart'
    as _i920;
import '../../features/chat/domain/usecases/dispose_typing_channel_usecase.dart'
    as _i157;
import '../../features/chat/domain/usecases/download_chat_file_usecase.dart'
    as _i971;
import '../../features/chat/domain/usecases/get_friends_usecase.dart' as _i50;
import '../../features/chat/domain/usecases/get_messages_usecase.dart' as _i325;
import '../../features/chat/domain/usecases/get_presence_usecase.dart' as _i904;
import '../../features/chat/domain/usecases/send_message_usecase.dart' as _i795;
import '../../features/chat/domain/usecases/send_typing_usecase.dart' as _i372;
import '../../features/chat/domain/usecases/subscribe_friends_realtime_usecase.dart'
    as _i289;
import '../../features/chat/domain/usecases/subscribe_messages_usecase.dart'
    as _i940;
import '../../features/chat/domain/usecases/subscribe_typing_usecase.dart'
    as _i553;
import '../../features/chat/domain/usecases/update_friend_status_usecase.dart'
    as _i578;
import '../../features/chat/domain/usecases/upload_chat_file_usecase.dart'
    as _i611;
import '../../features/chat/domain/usecases/upload_chat_image_usecase.dart'
    as _i829;
import '../../features/chat/infrastructure/datasources/chat_media_datasource.dart'
    as _i396;
import '../../features/chat/infrastructure/datasources/chat_messages_datasource.dart'
    as _i759;
import '../../features/chat/infrastructure/datasources/friends_datasource.dart'
    as _i38;
import '../../features/chat/infrastructure/datasources/typing_datasource.dart'
    as _i677;
import '../../features/chat/presentation/stores/conversation_detail_store.dart'
    as _i855;
import '../../features/chat/presentation/stores/friend_list_store.dart'
    as _i512;
import '../../features/chat/presentation/stores/typing_store.dart' as _i818;
import '../../features/home/data/repositories/discover_repository_impl.dart'
    as _i90;
import '../../features/home/domain/repositories/discover_repository.dart'
    as _i952;
import '../../features/home/domain/usecases/get_discover_batch_usecase.dart'
    as _i236;
import '../../features/home/domain/usecases/submit_swipe_usecase.dart' as _i219;
import '../../features/home/presentation/stores/discover_store.dart' as _i436;
import '../../features/home/presentation/stores/profile_store.dart' as _i937;
import '../network/dio_client.dart' as _i667;
import '../network/network_info.dart' as _i932;
import '../services/firebase_messaging_service.dart' as _i910;
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
    gh.lazySingleton<_i307.PresenceDatasource>(
      () => _i307.PresenceDatasource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i759.ChatMessagesDatasource>(
      () => _i759.ChatMessagesDatasource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i38.FriendsDatasource>(
      () => _i38.FriendsDatasource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i677.TypingDatasource>(
      () => _i677.TypingDatasource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i396.ChatMediaDatasource>(
      () => _i396.ChatMediaDatasource(gh<_i606.ImageUploadService>()),
    );
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
    gh.factory<_i82.GetUserProfileUseCase>(
      () => _i82.GetUserProfileUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i910.FirebaseMessagingService>(
      () => _i910.FirebaseMessagingService(gh<_i454.SupabaseClient>()),
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
    gh.factory<_i122.ChatMediaRepository>(
      () => _i785.ChatMediaRepositoryImpl(gh<_i396.ChatMediaDatasource>()),
    );
    gh.lazySingleton<_i389.AlbumRemoteDataSource>(
      () => _i389.AlbumRemoteDataSource(
        gh<_i454.SupabaseClient>(),
        gh<_i606.ImageUploadService>(),
      ),
    );
    gh.factory<_i185.TypingRepository>(
      () => _i706.TypingRepositoryImpl(gh<_i677.TypingDatasource>()),
    );
    gh.factory<_i436.DiscoverStore>(
      () => _i436.DiscoverStore(
        gh<_i236.GetDiscoverBatchUseCase>(),
        gh<_i219.SubmitSwipeUseCase>(),
      ),
    );
    gh.factory<_i473.FriendsRepository>(
      () => _i189.FriendsRepositoryImpl(gh<_i38.FriendsDatasource>()),
    );
    gh.factory<_i354.CheckFriendshipUseCase>(
      () => _i354.CheckFriendshipUseCase(gh<_i473.FriendsRepository>()),
    );
    gh.factory<_i50.GetFriendsUseCase>(
      () => _i50.GetFriendsUseCase(gh<_i473.FriendsRepository>()),
    );
    gh.factory<_i289.SubscribeFriendsRealtimeUseCase>(
      () =>
          _i289.SubscribeFriendsRealtimeUseCase(gh<_i473.FriendsRepository>()),
    );
    gh.factory<_i578.UpdateFriendStatusUseCase>(
      () => _i578.UpdateFriendStatusUseCase(gh<_i473.FriendsRepository>()),
    );
    gh.factory<_i850.PresenceRepository>(
      () => _i513.PresenceRepositoryImpl(gh<_i307.PresenceDatasource>()),
    );
    gh.lazySingleton<_i544.IAlbumRepository>(
      () => _i13.AlbumRepositoryImpl(gh<_i389.AlbumRemoteDataSource>()),
    );
    gh.factory<_i420.ChatRepository>(
      () => _i504.ChatRepositoryImpl(gh<_i759.ChatMessagesDatasource>()),
    );
    gh.factory<_i325.GetMessagesUseCase>(
      () => _i325.GetMessagesUseCase(gh<_i420.ChatRepository>()),
    );
    gh.factory<_i904.GetPresenceUseCase>(
      () => _i904.GetPresenceUseCase(gh<_i420.ChatRepository>()),
    );
    gh.factory<_i795.SendMessageUseCase>(
      () => _i795.SendMessageUseCase(gh<_i420.ChatRepository>()),
    );
    gh.factory<_i940.SubscribeMessagesUseCase>(
      () => _i940.SubscribeMessagesUseCase(gh<_i420.ChatRepository>()),
    );
    gh.lazySingleton<_i603.AuthStore>(
      () => authModule.authStore(
        gh<_i696.AuthDatasource>(),
        gh<_i606.ImageUploadService>(),
      ),
    );
    gh.factory<_i920.CreateTypingChannelUseCase>(
      () => _i920.CreateTypingChannelUseCase(gh<_i185.TypingRepository>()),
    );
    gh.factory<_i157.DisposeTypingChannelUseCase>(
      () => _i157.DisposeTypingChannelUseCase(gh<_i185.TypingRepository>()),
    );
    gh.factory<_i372.SendTypingUseCase>(
      () => _i372.SendTypingUseCase(gh<_i185.TypingRepository>()),
    );
    gh.factory<_i553.SubscribeTypingUseCase>(
      () => _i553.SubscribeTypingUseCase(gh<_i185.TypingRepository>()),
    );
    gh.factory<_i971.DownloadChatFileUseCase>(
      () => _i971.DownloadChatFileUseCase(gh<_i122.ChatMediaRepository>()),
    );
    gh.factory<_i611.UploadChatFileUseCase>(
      () => _i611.UploadChatFileUseCase(gh<_i122.ChatMediaRepository>()),
    );
    gh.factory<_i829.UploadChatImageUseCase>(
      () => _i829.UploadChatImageUseCase(gh<_i122.ChatMediaRepository>()),
    );
    gh.factory<_i512.FriendListStore>(
      () => _i512.FriendListStore(
        gh<_i50.GetFriendsUseCase>(),
        gh<_i289.SubscribeFriendsRealtimeUseCase>(),
      ),
    );
    gh.factory<_i655.SetOfflineUseCase>(
      () => _i655.SetOfflineUseCase(gh<_i850.PresenceRepository>()),
    );
    gh.factory<_i700.UpdatePresenceUseCase>(
      () => _i700.UpdatePresenceUseCase(gh<_i850.PresenceRepository>()),
    );
    gh.lazySingleton<_i499.InterestsStore>(
      () => authModule.interestsStore(
        gh<_i696.AuthDatasource>(),
        gh<_i603.AuthStore>(),
      ),
    );
    gh.factory<_i593.DeleteAlbumImageUseCase>(
      () => _i593.DeleteAlbumImageUseCase(gh<_i544.IAlbumRepository>()),
    );
    gh.factory<_i908.GetMyAlbumImagesUseCase>(
      () => _i908.GetMyAlbumImagesUseCase(gh<_i544.IAlbumRepository>()),
    );
    gh.factory<_i379.UploadAlbumImageUseCase>(
      () => _i379.UploadAlbumImageUseCase(gh<_i544.IAlbumRepository>()),
    );
    gh.factory<_i937.ProfileStore>(
      () => _i937.ProfileStore(
        gh<_i82.GetUserProfileUseCase>(),
        gh<_i354.CheckFriendshipUseCase>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.factory<_i855.ConversationDetailStore>(
      () => _i855.ConversationDetailStore(
        gh<_i325.GetMessagesUseCase>(),
        gh<_i795.SendMessageUseCase>(),
        gh<_i940.SubscribeMessagesUseCase>(),
        gh<_i904.GetPresenceUseCase>(),
        gh<_i829.UploadChatImageUseCase>(),
        gh<_i611.UploadChatFileUseCase>(),
        gh<_i971.DownloadChatFileUseCase>(),
      ),
    );
    gh.factory<_i818.TypingStore>(
      () => _i818.TypingStore(
        gh<_i920.CreateTypingChannelUseCase>(),
        gh<_i553.SubscribeTypingUseCase>(),
        gh<_i372.SendTypingUseCase>(),
        gh<_i157.DisposeTypingChannelUseCase>(),
      ),
    );
    gh.factory<_i378.PresenceStore>(
      () => _i378.PresenceStore(
        gh<_i700.UpdatePresenceUseCase>(),
        gh<_i655.SetOfflineUseCase>(),
      ),
    );
    gh.factory<_i964.AlbumStore>(
      () => _i964.AlbumStore(
        gh<_i908.GetMyAlbumImagesUseCase>(),
        gh<_i379.UploadAlbumImageUseCase>(),
        gh<_i593.DeleteAlbumImageUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}

class _$AuthModule extends _i784.AuthModule {}
