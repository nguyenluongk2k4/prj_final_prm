class AuthResponse<T> {
  final bool success;
  final T? data;
  final String? errorMessage;

  AuthResponse({
    required this.success,
    this.data,
    this.errorMessage,
  });

  factory AuthResponse.success(T data) {
    return AuthResponse(success: true, data: data);
  }

  factory AuthResponse.failure(String message) {
    return AuthResponse(success: false, errorMessage: message);
  }
}
