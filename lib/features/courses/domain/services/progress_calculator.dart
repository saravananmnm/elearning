double calculateProgress({
  required int completedLessons,
  required int totalLessons,
}) {
  if (totalLessons <= 0) {
    return 0.0;
  }

  return (completedLessons / totalLessons) * 100.0;
}
