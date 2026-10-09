import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:elearning/core/error/exceptions.dart';
import 'package:elearning/core/network/network_info.dart';
import 'package:elearning/features/courses/data/datasources/course_local_data_source.dart';
import 'package:elearning/features/courses/data/datasources/course_remote_data_source.dart';
import 'package:elearning/features/courses/data/repositories/course_repository_impl.dart';
import 'package:elearning/features/courses/domain/entities/course.dart';
import 'package:elearning/features/courses/domain/entities/lesson.dart';

class MockCourseRemoteDataSource extends Mock
    implements CourseRemoteDataSource {}

class MockCourseLocalDataSource extends Mock
    implements CourseLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProviderContainer container;
  late MockCourseRemoteDataSource mockRemoteDataSource;
  late MockCourseLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockCourseRemoteDataSource();
    mockLocalDataSource = MockCourseLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    container = ProviderContainer(
      overrides: [
        courseRemoteDataSourceProvider.overrideWithValue(mockRemoteDataSource),
        courseLocalDataSourceProvider.overrideWithValue(mockLocalDataSource),
        networkInfoProvider.overrideWithValue(mockNetworkInfo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  const testCourses = [
    Course(
      id: 1,
      title: 'Cached Course 1',
      instructor: 'Test Instructor',
      progress: 50,
      lessons: [
        Lesson(id: 1, title: 'Lesson 1', isCompleted: true),
        Lesson(id: 2, title: 'Lesson 2', isCompleted: false),
      ],
    ),
  ];

  group('CourseRepository Real-Time Connectivity Tests', () {
    test(
        'Given remote API succeeds, when getCourses called, then return merged cached courses',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getCourses())
          .thenAnswer((_) async => testCourses);
      when(() => mockLocalDataSource.saveCourses(testCourses))
          .thenAnswer((_) async => {});
      when(() => mockLocalDataSource.getCourses())
          .thenAnswer((_) async => testCourses);

      final repository = container.read(courseRepositoryProvider);

      // Act
      final result = await repository.getCourses();

      // Assert
      expect(result, equals(testCourses));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.getCourses()).called(1);
      verify(() => mockLocalDataSource.saveCourses(testCourses)).called(1);
      verify(() => mockLocalDataSource.getCourses()).called(2);
    });

    test(
        'Given device is offline and local cache contains courses, when getCourses called, then load offline data directly',
        () async {
      // Arrange: Device is offline
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getCourses())
          .thenAnswer((_) async => testCourses);

      final repository = container.read(courseRepositoryProvider);

      // Act
      final result = await repository.getCourses();

      // Assert
      expect(result, equals(testCourses));
      verify(() => mockNetworkInfo.isConnected).called(1);
      verifyZeroInteractions(mockRemoteDataSource);
      verify(() => mockLocalDataSource.getCourses()).called(1);
    });

    test(
        'Given device is offline and local cache is empty, when getCourses called, then throw NetworkException',
        () async {
      // Arrange: Device is offline
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getCourses())
          .thenAnswer((_) async => []);

      final repository = container.read(courseRepositoryProvider);

      // Act & Assert
      await expectLater(
        repository.getCourses(),
        throwsA(isA<NetworkException>()),
      );
      verify(() => mockNetworkInfo.isConnected).called(1);
      verifyZeroInteractions(mockRemoteDataSource);
      verify(() => mockLocalDataSource.getCourses()).called(1);
    });
  });
}
