import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:elearning/core/database/hive_helper.dart';
import 'package:elearning/features/courses/data/datasources/course_local_data_source.dart';
import 'package:elearning/features/courses/domain/entities/course.dart';
import 'package:elearning/features/courses/domain/entities/lesson.dart';

class MockHiveHelper extends Mock implements HiveHelper {}
class MockBox extends Mock implements Box<dynamic> {}

void main() {
  late MockHiveHelper mockHiveHelper;
  late MockBox mockBox;
  late CourseLocalDataSourceImpl dataSource;

  const testCourse = Course(
    id: 1,
    title: 'Flutter Test Course',
    instructor: 'Tester',
    progress: 50,
    lessons: [
      Lesson(id: 101, title: 'Lesson 1', isCompleted: true),
      Lesson(id: 102, title: 'Lesson 2', isCompleted: false),
    ],
  );

  setUp(() {
    mockHiveHelper = MockHiveHelper();
    mockBox = MockBox();
    dataSource = CourseLocalDataSourceImpl(hiveHelper: mockHiveHelper);
    when(() => mockHiveHelper.coursesBox).thenAnswer((_) async => mockBox);
  });

  group('CourseLocalDataSourceImpl saveCourses', () {
    test('saveCourses successfully puts json strings without type cast errors', () async {
      when(() => mockBox.get(1)).thenReturn(null);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      await expectLater(
        dataSource.saveCourses([testCourse]),
        completes,
      );

      verify(() => mockBox.put(1, any(that: isA<String>()))).called(1);
    });

    test('getCourses successfully parses json strings from box', () async {
      when(() => mockBox.isEmpty).thenReturn(false);
      when(() => mockBox.keys).thenReturn([1]);
      when(() => mockBox.get(1)).thenReturn(
        '{"id":1,"title":"Flutter Test Course","instructor":"Tester","progress":50,"lessons":[{"id":101,"title":"Lesson 1","isCompleted":true}]}',
      );

      final courses = await dataSource.getCourses();

      expect(courses.length, 1);
      expect(courses.first.id, 1);
      expect(courses.first.title, 'Flutter Test Course');
    });
  });
}
