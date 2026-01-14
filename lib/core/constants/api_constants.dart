class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = '/v1';
  
  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Headers
  static const String contentType = 'Content-Type';
  static const String authorization = 'Authorization';
  static const String applicationJson = 'application/json';
}
