import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../viewmodels/courses_viewmodel.dart';
import '../widgets/course_card.dart';
import '../widgets/empty_courses_view.dart';
import '../widgets/error_view.dart';

class CoursesPage extends ConsumerWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(coursesViewModelProvider);
    final isOnlineAsync = ref.watch(connectivityStreamProvider);
    final isOffline = isOnlineAsync.value == false;

    // Automatically refresh courses list when connectivity transitions from offline to online
    ref.listen<AsyncValue<bool>>(connectivityStreamProvider, (previous, next) {
      final wasOffline = previous?.value == false;
      final isNowOnline = next.value == true;
      if (wasOffline && isNowOnline) {
        Future.microtask(() {
          ref.read(coursesViewModelProvider.notifier).refreshCourses();
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          if (isOffline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.amber.shade800,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Offline Mode — Showing cached courses',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => ErrorView(
                message: error.toString(),
                onRetry: () {
                  ref.read(coursesViewModelProvider.notifier).refreshCourses();
                },
              ),
              data: (courses) {
                if (courses.isEmpty) {
                  return EmptyCoursesView(
                    onRefresh: () {
                      ref
                          .read(coursesViewModelProvider.notifier)
                          .refreshCourses();
                    },
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(coursesViewModelProvider.notifier)
                        .refreshCourses();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return CourseCard(
                        course: course,
                        onTap: () {
                          context.go('/courses/${course.id}');
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
