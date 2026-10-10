import 'dart:async';
import 'package:elearning/features/courses/presentation/viewmodels/course_details_viewmodel.dart';
import 'package:elearning/features/courses/presentation/viewmodels/courses_viewmodel.dart';
import 'package:elearning/features/courses/presentation/widgets/error_view.dart';
import 'package:elearning/features/courses/presentation/widgets/lesson_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CourseDetailsPage extends ConsumerWidget {
  final int courseId;

  const CourseDetailsPage({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(courseDetailsViewModelProvider(courseId));
    final colorScheme = Theme.of(context).colorScheme;

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

            final completedLessons =
                course.lessons.where((l) => l.isCompleted).length;
            final totalLessons = course.lessons.length;

            final headerWidget = Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    course.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person,
                          size: 18, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        'Instructor: ${course.instructor}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$completedLessons / $totalLessons lessons completed',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                      ),
                      Text(
                        '${course.progress}%',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
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
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        course.progress == 100
                            ? Colors.green
                            : colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 700;

                if (isWide) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 340,
                          child: headerWidget,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lessons',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                              ),
                              const SizedBox(height: 8),
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
                                              courseDetailsViewModelProvider(
                                                      courseId)
                                                  .notifier,
                                            )
                                            .toggleLessonCompletion(lesson.id);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerWidget,
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Lessons',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
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
            );
          },
        ),
      ),
    );
  }
}
