class UserProfile {
  final String name;
  final int dailyStreak;
  final int totalTasks;
  final bool reminderEnabled;
  final DateTime? lastCompletedDate;

  UserProfile({
    required this.name,
    this.dailyStreak = 0,
    this.totalTasks = 0,
    this.reminderEnabled = true,
    this.lastCompletedDate,
  });

  UserProfile copyWith({
    String? name,
    int? dailyStreak,
    int? totalTasks,
    bool? reminderEnabled,
    DateTime? lastCompletedDate,
  }) {
    return UserProfile(
      name: name ?? this.name,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      totalTasks: totalTasks ?? this.totalTasks,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }
}
