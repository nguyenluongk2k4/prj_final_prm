import 'package:injectable/injectable.dart';

/// Interface để check network connectivity
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation của NetworkInfo
/// TODO: Thêm connectivity_plus package nếu cần check network thật
@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // TODO: Implement với connectivity_plus package
    return true;
  }
}
