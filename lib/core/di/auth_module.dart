import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/infrastructure/datasources/auth_datasource.dart';
import '../../features/auth/presentation/stores/auth_store.dart';
import '../../features/auth/presentation/stores/interests_store.dart';
import '../services/image_upload_service.dart';

@module
abstract class AuthModule {
  @lazySingleton
  AuthDatasource authDatasource(SupabaseClient client) => AuthDatasource(supabaseClient: client);

  @lazySingleton
  AuthStore authStore(AuthDatasource datasource, ImageUploadService imageUploadService) => 
      AuthStore(authDatasource: datasource, imageUploadService: imageUploadService);

  @lazySingleton
  InterestsStore interestsStore(AuthDatasource datasource, AuthStore authStore) =>
      InterestsStore(authDatasource: datasource, authStore: authStore);
}
