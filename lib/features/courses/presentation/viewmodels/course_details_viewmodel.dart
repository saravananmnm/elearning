import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../domain/entities/course.dart';
import '../../domain/services/progress_calculator.dart';
import 'courses_viewmodel.dart';

final courseDetailsViewModelProvider =
    AsyncNotifierProvider.family<CourseDetailsViewModel, Course?, int>(
  CourseDetailsViewModel.new,
);

class CourseDetailsViewModel extends FamilyAsyncNotifier<Course?, int> {
  @override
  FutureOr<Course?> build(int arg) async {
    final repository = ref.read(courseRepositoryProvider);
    return repository.getCourseById(arg);
  }

  Future<void> toggleLessonCompletion(int lessonId) async {
    final currentCourse = state.value;
    if (currentCourse == null) return;

    final repository = ref.read(courseRepositoryProvider);

    // Update in local database/repository
    await repository.markLessonCompleted(
      courseId: currentCourse.id,
      lessonId: lessonId,
    );

    // Recalculate lessons state
    final updatedLessons = currentCourse.lessons.map((lesson) {
      if (lesson.id == lessonId) {
        return lesson.copyWith(isCompleted: !lesson.isCompleted);
      }
      return lesson;
    }).toList();

    final completedCount = updatedLessons.where((l) => l.isCompleted).length;
    final newProgress = calculateProgress(
      completedLessons: completedCount,
      totalLessons: updatedLessons.length,
    ).round();

    final updatedCourse = currentCourse.copyWith(
      lessons: updatedLessons,
      progress: newProgress,
    );

    // Update state locally
    state = AsyncData(updatedCourse);

    // Refresh courses list viewmodel asynchronously after current build cycle
    Future.microtask(() {
      ref.read(coursesViewModelProvider.notifier).refreshCourses();
    });
  }
}
