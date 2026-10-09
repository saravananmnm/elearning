import 'package:flutter_test/flutter_test.dart';
import 'package:elearning/features/courses/domain/entities/course.dart';
import 'package:elearning/features/courses/domain/entities/lesson.dart';

void main() {
  group('Course Model Serialization Tests', () {
    test('Course.fromJson parses standard JSON correctly', () {
      final json = {
        'id': 101,
        'title': 'Flutter Basics',
        'instructor': 'John Doe',
        'progress': 25,
        'lessons': [
          {'id': 1, 'title': 'Intro', 'isCompleted': true},
          {'id': 2, 'title': 'Widgets', 'isCompleted': false},
        ],
      };

      final course = Course.fromJson(json);

      expect(course.id, equals(101));
      expect(course.title, equals('Flutter Basics'));
      expect(course.instructor, equals('John Doe'));
      expect(course.progress, equals(25));
      expect(course.lessons.length, equals(2));
      expect(course.lessons.first.isCompleted, isTrue);
    });

    test('Course.fromJson handles raw Map<dynamic, dynamic> from Hive correctly', () {
      final Map<dynamic, dynamic> rawHiveMap = {
        'id': 202,
        'title': 'Hive NoSQL Course',
        'instructor': 'Sarah Chen',
        'progress': 50,
        'lessons': [
          <dynamic, dynamic>{'id': 101, 'title': 'Lesson A', 'isCompleted': true},
          <dynamic, dynamic>{'id': 102, 'title': 'Lesson B', 'isCompleted': false},
        ],
      };

      final convertedMap = Map<String, dynamic>.from(
        rawHiveMap.map((k, v) => MapEntry(k.toString(), v)),
      );

      final course = Course.fromJson(convertedMap);

      expect(course.id, equals(202));
      expect(course.title, equals('Hive NoSQL Course'));
      expect(course.progress, equals(50));
      expect(course.lessons.length, equals(2));
      expect(course.lessons[0].isCompleted, isTrue);
      expect(course.lessons[1].isCompleted, isFalse);
    });

    test('Course.toJson returns correct JSON map', () {
      const course = Course(
        id: 1,
        title: 'Dart Basics',
        instructor: 'Jane Smith',
        progress: 100,
        lessons: [
          Lesson(id: 10, title: 'Variables', isCompleted: true),
        ],
      );

      final json = course.toJson();

      expect(json['id'], equals(1));
      expect(json['title'], equals('Dart Basics'));
      expect(json['instructor'], equals('Jane Smith'));
      expect(json['progress'], equals(100));
      expect((json['lessons'] as List).length, equals(1));
    });
  });
}
