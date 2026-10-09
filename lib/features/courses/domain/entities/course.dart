import 'lesson.dart';

class Course {
  final int id;
  final String title;
  final String instructor;
  final int progress;
  final List<Lesson> lessons;

  const Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.progress,
    required this.lessons,
  });

  Course copyWith({
    int? id,
    String? title,
    String? instructor,
    int? progress,
    List<Lesson>? lessons,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
      progress: progress ?? this.progress,
      lessons: lessons ?? this.lessons,
    );
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    final rawLessons = json['lessons'] as List<dynamic>? ?? [];
    return Course(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      instructor: json['instructor'] as String,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      lessons: rawLessons.map((item) {
        if (item is Map) {
          final lessonMap = Map<String, dynamic>.from(
            item.map((k, v) => MapEntry(k.toString(), v)),
          );
          return Lesson.fromJson(lessonMap);
        }
        return Lesson.fromJson(item as Map<String, dynamic>);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instructor': instructor,
      'progress': progress,
      'lessons': lessons.map((item) => item.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          instructor == other.instructor &&
          progress == other.progress;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ instructor.hashCode ^ progress.hashCode;
}
