import 'package:elearning/features/courses/domain/entities/lesson.dart';
import 'package:flutter/material.dart';


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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      color: lesson.isCompleted
          ? colorScheme.primaryContainer.withValues(alpha: 0.3)
          : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          lesson.title,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: lesson.isCompleted
            ? Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Completed',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.green.shade300
                            : Colors.green.shade700,
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
                      color: colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Pending',
                      style: TextStyle(
                        color: colorScheme.outline,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
        value: lesson.isCompleted,
        onChanged: onChanged,
        activeColor: colorScheme.primary,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
