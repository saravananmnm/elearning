import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';

final loginViewModelProvider =
    AsyncNotifierProvider<LoginViewModel, User?>(
  LoginViewModel.new,
);

class LoginViewModel extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() async {
    final repository = ref.read(authRepositoryProvider);
    return repository.getCurrentUser();
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return repository.login(email, password);
    });

    return !state.hasError;
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
      return null;
    });
  }
}
