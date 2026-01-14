/// Base exception cho app
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Exception từ server
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
  });
}

/// Exception cache
class CacheException extends AppException {
  const CacheException({
    required super.message,
  });
}

/// Exception network
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
  });
}
