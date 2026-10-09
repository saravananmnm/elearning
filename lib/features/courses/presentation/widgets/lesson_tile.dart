import 'package:flutter/material.dart';

import '../../domain/entities/lesson.dart';

class LessonTile extends StatelessWidget {
  final Lesson lesson;
  final ValueChanged<bool?> onChanged;

  const LessonTile({
    super.key,
    required this.lesson,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      color: lesson.isCompleted
          ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
          : Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          lesson.title,
          style: TextStyle(
            decoration: lesson.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            fontWeight:
                lesson.isCompleted ? FontWeight.normal : FontWeight.w500,
          ),
        ),
        value: lesson.isCompleted,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
