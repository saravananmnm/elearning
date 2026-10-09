import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/user.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return MockAuthRemoteDataSource(dio: ref.read(dioProvider));
});

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
}

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  final Dio dio;

  MockAuthRemoteDataSource({required this.dio});

  @override
  Future<User> login(String email, String password) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 600));

    if (!email.contains('@') || password.isEmpty) {
      throw const AuthenticationException('Invalid email or password');
    }

    if (password.length < 6) {
      throw const AuthenticationException('Password must be at least 6 characters');
    }

    // Mock successful authentication
    return User(
      id: 'usr_101',
      email: email,
      name: email.split('@').first,
      token: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}
