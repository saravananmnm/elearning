import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../domain/entities/course.dart';

final coursesViewModelProvider =
    AsyncNotifierProvider<CoursesViewModel, List<Course>>(
  CoursesViewModel.new,
);

class CoursesViewModel extends AsyncNotifier<List<Course>> {
  @override
  Future<List<Course>> build() async {
    final repository = ref.read(courseRepositoryProvider);
    return repository.getCourses();
  }

  Future<void> refreshCourses() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.read(courseRepositoryProvider).getCourses();
    });
  }
}
