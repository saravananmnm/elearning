import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/hive_helper.dart';
import '../../domain/entities/course.dart';
import '../../domain/services/progress_calculator.dart';

final courseLocalDataSourceProvider = Provider<CourseLocalDataSource>((ref) {
  return CourseLocalDataSourceImpl(hiveHelper: ref.read(hiveHelperProvider));
});

abstract class CourseLocalDataSource {
  Future<void> saveCourses(List<Course> courses);

  Future<List<Course>> getCourses();

  Future<Course?> getCourseById(int courseId);

  Future<void> markLessonCompleted({
    required int courseId,
    required int lessonId,
  });
}

class CourseLocalDataSourceImpl implements CourseLocalDataSource {
  final HiveHelper hiveHelper;

  CourseLocalDataSourceImpl({required this.hiveHelper});

  Map<String, dynamic> _deepCastMap(dynamic raw) {
    if (raw is! Map) return {};
    final result = <String, dynamic>{};
    raw.forEach((key, value) {
      final strKey = key.toString();
      if (value is Map) {
        result[strKey] = _deepCastMap(value);
      } else if (value is List) {
        result[strKey] = value.map((item) {
          if (item is Map) {
            return _deepCastMap(item);
          }
          return item;
        }).toList();
      } else {
        result[strKey] = value;
      }
    });
    return result;
  }

  Course? _parseCourse(dynamic raw) {
    if (raw == null) return null;
    try {
      if (raw is String) {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          return Course.fromJson(_deepCastMap(decoded));
        }
      } else if (raw is Map) {
        return Course.fromJson(_deepCastMap(raw));
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  @override
  Future<void> saveCourses(List<Course> courses) async {
    final box = await hiveHelper.coursesBox;
    for (final course in courses) {
      final existingRawMap = box.get(course.id);
      final existingCourse = _parseCourse(existingRawMap);

      if (existingCourse != null) {
        final completedLessonIds = existingCourse.lessons
            .where((l) => l.isCompleted)
            .map((l) => l.id)
            .toSet();

        final mergedLessons = course.lessons.map((lesson) {
          if (completedLessonIds.contains(lesson.id)) {
            return lesson.copyWith(isCompleted: true);
          }
          return lesson;
        }).toList();

        final completedCount = mergedLessons.where((l) => l.isCompleted).length;
        final newProgress = calculateProgress(
          completedLessons: completedCount,
          totalLessons: mergedLessons.length,
        ).round();

        final mergedCourse = course.copyWith(
          lessons: mergedLessons,
          progress: newProgress,
        );
        await box.put(course.id, jsonEncode(mergedCourse.toJson()) as Map<dynamic, dynamic>);
      } else {
        await box.put(course.id, jsonEncode(course.toJson()) as Map<dynamic, dynamic>);
      }
    }
  }

  @override
  Future<List<Course>> getCourses() async {
    final box = await hiveHelper.coursesBox;
    if (box.isEmpty) {
      return [];
    }

    final courses = <Course>[];
    for (final key in box.keys) {
      final rawData = box.get(key);
      final course = _parseCourse(rawData);
      if (course != null) {
        courses.add(course);
      }
    }
    return courses;
  }

  @override
  Future<Course?> getCourseById(int courseId) async {
    final box = await hiveHelper.coursesBox;
    final rawData = box.get(courseId);
    return _parseCourse(rawData);
  }

  @override
  Future<void> markLessonCompleted({
    required int courseId,
    required int lessonId,
  }) async {
    final course = await getCourseById(courseId);
    if (course == null) return;

    final updatedLessons = course.lessons.map((lesson) {
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

    final updatedCourse = course.copyWith(
      lessons: updatedLessons,
      progress: newProgress,
    );

    final box = await hiveHelper.coursesBox;
    await box.put(courseId, jsonEncode(updatedCourse.toJson()));
  }
}
