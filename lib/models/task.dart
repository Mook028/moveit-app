class Task {
  final String id;
  final String title;
  final String mood; // 'Energetic', 'Normal', 'Tired'
  final int duration; // in minutes
  final bool completed;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.mood,
    required this.duration,
    this.completed = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    String? mood,
    int? duration,
    bool? completed,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      mood: mood ?? this.mood,
      duration: duration ?? this.duration,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
