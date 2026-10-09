import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:elearning/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:elearning/features/auth/domain/repositories/auth_repository.dart';
import 'package:elearning/main.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  testWidgets('App renders login page by default', (WidgetTester tester) async {
    final mockAuthRepository = MockAuthRepository();
    when(() => mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => null);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Welcome to E-Learning'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Sign In'), findsOneWidget);
  });
}
