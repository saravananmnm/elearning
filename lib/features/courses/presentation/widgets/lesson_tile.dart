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
          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
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
          style: const TextStyle(
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: lesson.isCompleted
            ? Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history,
                size: 14,
                color: Colors.pink.shade700,
              ),
              const SizedBox(width: 4),
              Text(
                'Pending',
                style: TextStyle(
                  color: Colors.pink.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
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
