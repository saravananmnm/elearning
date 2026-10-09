import 'package:flutter_test/flutter_test.dart';
import 'package:elearning/features/courses/domain/services/progress_calculator.dart';

void main() {
  group('Progress Calculator Tests', () {
    test('0 completed out of 0 total lessons returns 0', () {
      final progress = calculateProgress(completedLessons: 0, totalLessons: 0);
      expect(progress, equals(0.0));
    });

    test('0 completed out of 10 total lessons returns 0', () {
      final progress = calculateProgress(completedLessons: 0, totalLessons: 10);
      expect(progress, equals(0.0));
    });

    test('5 completed out of 10 total lessons returns 50', () {
      final progress = calculateProgress(completedLessons: 5, totalLessons: 10);
      expect(progress, equals(50.0));
    });

    test('10 completed out of 10 total lessons returns 100', () {
      final progress = calculateProgress(completedLessons: 10, totalLessons: 10);
      expect(progress, equals(100.0));
    });

    test('Handles negative or invalid input gracefully', () {
      final progress = calculateProgress(completedLessons: 5, totalLessons: -1);
      expect(progress, equals(0.0));
    });
  });
}
