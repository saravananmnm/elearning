import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/course_details_viewmodel.dart';
import '../viewmodels/courses_viewmodel.dart';
import '../widgets/error_view.dart';
import '../widgets/lesson_tile.dart';

class CourseDetailsPage extends ConsumerWidget {
  final int courseId;

  const CourseDetailsPage({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(courseDetailsViewModelProvider(courseId));

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        Future.microtask(() {
          ref.read(coursesViewModelProvider.notifier).refreshCourses();
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Course Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Future.microtask(() {
                ref.read(coursesViewModelProvider.notifier).refreshCourses();
              });
              context.go('/courses');
            },
          ),
        ),
        body: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => ErrorView(
            message: error.toString(),
            onRetry: () {
              ref.invalidate(courseDetailsViewModelProvider(courseId));
            },
          ),
          data: (course) {
            if (course == null) {
              return const ErrorView(message: 'Course not found');
            }

            final completedLessons = course.lessons.where((l) => l.isCompleted).length;
            final totalLessons = course.lessons.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.person,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            'Instructor: ${course.instructor}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$completedLessons / $totalLessons lessons completed',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '${course.progress}%',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: course.progress / 100.0,
                          minHeight: 10,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            course.progress == 100
                                ? Colors.green
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Lessons',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: course.lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = course.lessons[index];
                      return LessonTile(
                        lesson: lesson,
                        onChanged: (_) {
                          ref
                              .read(
                                courseDetailsViewModelProvider(courseId)
                                    .notifier,
                              )
                              .toggleLessonCompletion(lesson.id);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
