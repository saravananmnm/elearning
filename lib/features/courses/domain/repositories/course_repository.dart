import '../entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses();

  Future<Course?> getCourseById(int courseId);

  Future<void> markLessonCompleted({
    required int courseId,
    required int lessonId,
  });
}
