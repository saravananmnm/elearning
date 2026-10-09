class Lesson {
  final int id;
  final String title;
  final bool isCompleted;

  const Lesson({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  Lesson copyWith({
    int? id,
    String? title,
    bool? isCompleted,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ??
          (json['is_completed'] == 1 || json['is_completed'] == true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lesson &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ isCompleted.hashCode;
}
