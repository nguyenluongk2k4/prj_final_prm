import 'package:injectable/injectable.dart';
import '../models/user_model.dart';

/// Local DataSource Interface
abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
}

/// Local DataSource Implementation
/// TODO: Implement với SharedPreferences hoặc Hive
@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<UserModel?> getCachedUser() async {
    // TODO: Implement
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    // TODO: Implement
  }

  @override
  Future<void> clearCache() async {
    // TODO: Implement
  }
}
