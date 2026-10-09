import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/lesson.dart';

final courseRemoteDataSourceProvider =
    Provider<CourseRemoteDataSource>((ref) {
  return MockCourseRemoteDataSource(
    dio: ref.read(dioProvider),
  );
});

abstract class CourseRemoteDataSource {
  Future<List<Course>> getCourses();
}

class MockCourseRemoteDataSource implements CourseRemoteDataSource {
  final Dio dio;
  bool isNetworkAvailable;

  MockCourseRemoteDataSource({
    required this.dio,
    this.isNetworkAvailable = true,
  });

  @override
  Future<List<Course>> getCourses() async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (!isNetworkAvailable) {
      throw const NetworkException('No internet connection');
    }

    return _mockCourses;
  }

  static final List<Course> _mockCourses = [
    const Course(
      id: 1,
      title: 'Flutter Architecture & State Management',
      instructor: 'Alex Rivera',
      progress: 40,
      lessons: [
        Lesson(id: 101, title: 'Introduction to MVVM', isCompleted: true),
        Lesson(id: 102, title: 'Riverpod 2.0 Essentials', isCompleted: true),
        Lesson(id: 103, title: 'Repository Pattern & Data Flow', isCompleted: false),
        Lesson(id: 104, title: 'Offline-First Caching Strategy', isCompleted: false),
        Lesson(id: 105, title: 'Testing ViewModels with Mocktail', isCompleted: false),
      ],
    ),
    const Course(
      id: 2,
      title: 'Advanced Dart & Asynchronous Programming',
      instructor: 'Sarah Chen',
      progress: 66,
      lessons: [
        Lesson(id: 201, title: 'Generators and Streams Deep Dive', isCompleted: true),
        Lesson(id: 202, title: 'Isolates and Concurrency', isCompleted: true),
        Lesson(id: 203, title: 'Extension Types and Pattern Matching', isCompleted: false),
      ],
    ),
    const Course(
      id: 3,
      title: 'UI Design with Material 3 in Flutter',
      instructor: 'Marcus Vance',
      progress: 0,
      lessons: [
        Lesson(id: 301, title: 'Material You Color Schemes', isCompleted: false),
        Lesson(id: 302, title: 'Dynamic Layouts and Navigation Bar', isCompleted: false),
        Lesson(id: 303, title: 'Custom Animations & Hero Transitions', isCompleted: false),
        Lesson(id: 304, title: 'Responsive Design Strategies', isCompleted: false),
      ],
    ),
  ];
}
