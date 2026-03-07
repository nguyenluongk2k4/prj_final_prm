/// Base class cho tất cả failures trong app
abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });
}

/// Lỗi từ server
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });
}

/// Lỗi cache/local storage
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
  });
}

/// Lỗi network/kết nối
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
  });
}

/// Lỗi validation
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
  });
}

/// Lỗi unauthorized
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized',
  }) : super(statusCode: 401);
}
