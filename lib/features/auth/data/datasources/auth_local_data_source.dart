import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(storage: ref.read(secureStorageProvider));
});

abstract class AuthLocalDataSource {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService storage;

  AuthLocalDataSourceImpl({required this.storage});

  @override
  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await storage.write(AppConstants.userKey, userJson);
    if (user.token != null) {
      await storage.write(AppConstants.tokenKey, user.token!);
    }
  }

  @override
  Future<User?> getUser() async {
    final userJson = await storage.read(AppConstants.userKey);
    if (userJson == null || userJson.isEmpty) {
      return null;
    }
    try {
      final map = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    await storage.delete(AppConstants.userKey);
    await storage.delete(AppConstants.tokenKey);
  }
}
