import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_local_data_source.dart';
import '../datasources/course_remote_data_source.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepositoryImpl(
    remoteDataSource: ref.read(courseRemoteDataSourceProvider),
    localDataSource: ref.read(courseLocalDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;
  final CourseLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CourseRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Course>> getCourses() async {
    final cachedCourses = await localDataSource.getCourses();
    final isOnline = await networkInfo.isConnected;

    if (isOnline) {
      try {
        final remoteCourses = await remoteDataSource.getCourses();
        await localDataSource.saveCourses(remoteCourses);
        return await localDataSource.getCourses();
      } catch (e) {
        if (cachedCourses.isNotEmpty) {
          return cachedCourses;
        }
        if (e is Exception) rethrow;
        throw NetworkException(e.toString());
      }
    } else {
      if (cachedCourses.isNotEmpty) {
        return cachedCourses;
      }
      throw const NetworkException(
        'You are offline and no cached courses are available.',
      );
    }
  }

  @override
  Future<Course?> getCourseById(int courseId) async {
    final cached = await localDataSource.getCourseById(courseId);
    if (cached != null) {
      return cached;
    }

    final courses = await getCourses();
    try {
      return courses.firstWhere((c) => c.id == courseId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> markLessonCompleted({
    required int courseId,
    required int lessonId,
  }) async {
    await localDataSource.markLessonCompleted(
      courseId: courseId,
      lessonId: lessonId,
    );
  }
}
