import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/viewmodels/login_viewmodel.dart';
import '../../features/courses/presentation/pages/course_details_page.dart';
import '../../features/courses/presentation/pages/courses_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final loginState = ref.watch(loginViewModelProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = loginState.asData?.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/courses';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/courses',
        builder: (context, state) => const CoursesPage(),
        routes: [
          GoRoute(
            path: ':courseId',
            builder: (context, state) {
              final courseIdStr = state.pathParameters['courseId'];
              final courseId = int.tryParse(courseIdStr ?? '') ?? 0;
              return CourseDetailsPage(courseId: courseId);
            },
          ),
        ],
      ),
    ],
  );
});
