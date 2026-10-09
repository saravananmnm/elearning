class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'Network error occurred']);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache error occurred']);

  @override
  String toString() => message;
}

class AuthenticationException implements Exception {
  final String message;

  const AuthenticationException([this.message = 'Authentication failed']);

  @override
  String toString() => message;
}
