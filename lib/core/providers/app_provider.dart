import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/task.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import 'dart:convert';
import 'dart:typed_data';

enum DayStatus { none, someComplete, allComplete, inProgress }

class AppProvider extends ChangeNotifier {
  static const String _lastActiveDateKey = 'lastActiveDate';

  late UserProfile user;
  String? selectedMood;
  String? profileImagePath;

  Map<String, DayStatus> taskStatusMap = {};

  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  void setDayStatus(DateTime date, DayStatus status) {
    final key = _formatDateKey(date);
    print("SET STATUS: $status");
    taskStatusMap[key] = status;
    saveStatus();
    notifyListeners();
  }

  DayStatus getDayStatus(DateTime date) {
    final key = _formatDateKey(date);
    return taskStatusMap[key] ?? DayStatus.none;
  }

  Future<void> saveStatus() async {
    final prefs = await SharedPreferences.getInstance();

    final map = taskStatusMap.map((key, value) => MapEntry(key, value.index));

    prefs.setString('task_status', jsonEncode(map));
  }

  Future<void> loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('task_status');

    if (data != null) {
      final decoded = jsonDecode(data) as Map<String, dynamic>;

      taskStatusMap = decoded.map(
        (key, value) => MapEntry(key, DayStatus.values[value]),
      );

      notifyListeners();
    }
  }

  Future<void> setProfileImage(String path) async {
    profileImagePath = path;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', path);

    notifyListeners();
  }

  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    profileImagePath = prefs.getString('profile_image');

    notifyListeners();
  }

  bool _isMoodConfirmed = false;
  bool get isMoodConfirmed => _isMoodConfirmed;
  List<Task> tasks = [];
  int dailyStreak = 0;
  int totalCompleted = 0;
  bool reminderEnabled = true;
  bool hasNavigatedToStatsToday = false;
  final UserService _userService = UserService();
  String? _currentUserId;
  DateTime? _lastActiveDate;
  bool _hasCheckedDayBoundary = false;
  bool _shouldRedirectToMoodForNewDay = false;
  final Set<int> _completionHistoryDateKeys = {};
  // Tracks per-day task completion state using yyyy-mm-dd keys.
  final Map<String, DayStatus> _dailyStatus = {};

  Map<String, DayStatus> get dailyStatus => Map.unmodifiable(_dailyStatus);

  DateTime? get lastActiveDate => _lastActiveDate;
  bool get hasCheckedDayBoundary => _hasCheckedDayBoundary;
  bool get shouldRedirectToMoodForNewDay => _shouldRedirectToMoodForNewDay;

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  Future<void> loadUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    final user = await UserService().getUserProfile(uid);

    _userProfile = user;

    notifyListeners();
  }

  int _toDateKey(DateTime date) {
    return DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
  }

  String formatDateKey(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final year = normalized.year.toString().padLeft(4, '0');
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  void updateDayStatus(DateTime date, List<Task> tasks, {bool notify = true}) {
    if (!_isMoodConfirmed) return;

    final key = formatDateKey(date);

    if (tasks.isEmpty) {
      // No generated tasks for this date: keep calendar in default (grey) state.
      _dailyStatus.remove(key);
      if (notify) {
        notifyListeners();
      }
      return;
    }

    final completedCount = tasks.where((task) => task.completed).length;
    if (completedCount == 0) {
      _dailyStatus[key] = DayStatus.none;
    } else if (completedCount == tasks.length) {
      _dailyStatus[key] = DayStatus.allComplete;
    } else {
      _dailyStatus[key] = DayStatus.someComplete;
    }

    if (notify) {
      notifyListeners();
    }
  }

  AppProvider() {
    user = UserProfile(
      name: 'User',
      dailyStreak: 0,
      totalTasks: 0,
      reminderEnabled: true,
    );
    _initializeUser();
    _initializeLastActiveDate();
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _resetDailyStateForNewDay() {
    selectedMood = null;
    _isMoodConfirmed = false;
    tasks = [];
    hasNavigatedToStatsToday = false;
  }

  Future<void> _initializeLastActiveDate() async {
    final prefs = await SharedPreferences.getInstance();
    final storedMillis = prefs.getInt(_lastActiveDateKey);
    final today = _dateOnly(DateTime.now());

    if (storedMillis == null) {
      _lastActiveDate = today;
      _hasCheckedDayBoundary = true;
      _shouldRedirectToMoodForNewDay = false;
      await prefs.setInt(_lastActiveDateKey, today.millisecondsSinceEpoch);
      notifyListeners();
      return;
    }

    _lastActiveDate = _dateOnly(
      DateTime.fromMillisecondsSinceEpoch(storedMillis),
    );
    _hasCheckedDayBoundary = true;

    if (!_isSameDate(_lastActiveDate!, today)) {
      _resetDailyStateForNewDay();
      _shouldRedirectToMoodForNewDay = true;
    } else {
      _shouldRedirectToMoodForNewDay = false;
    }

    notifyListeners();
  }

  void evaluateDayBoundaryOnAppOpen() {
    if (!_hasCheckedDayBoundary || _lastActiveDate == null) return;

    final today = _dateOnly(DateTime.now());
    if (!_isSameDate(_lastActiveDate!, today) &&
        !_shouldRedirectToMoodForNewDay) {
      _resetDailyStateForNewDay();
      _shouldRedirectToMoodForNewDay = true;
      notifyListeners();
    }
  }

  Future<void> markMoodRedirectHandled() async {
    if (!_shouldRedirectToMoodForNewDay) return;

    final today = _dateOnly(DateTime.now());
    _lastActiveDate = today;
    _shouldRedirectToMoodForNewDay = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastActiveDateKey, today.millisecondsSinceEpoch);
  }

  void _initializeUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        _currentUserId = firebaseUser.uid;
        final profile = await _userService.getUserProfile(firebaseUser.uid);
        if (profile != null) {
          user = profile;
          dailyStreak = profile.dailyStreak;
          totalCompleted = profile.totalTasks;
          reminderEnabled = profile.reminderEnabled;
        } else {
          // Create new profile
          user = UserProfile(name: firebaseUser.displayName ?? 'User');
          await _userService.createUserProfile(firebaseUser.uid, user.name);
        }
        await refreshCompletionHistory(notify: false);
        notifyListeners();
      }
    });
  }

  Future<void> refreshCompletionHistory({bool notify = true}) async {
    if (_currentUserId == null) return;

    final completionHistory = await _userService.getCompletionHistory(
      _currentUserId!,
    );
    _completionHistoryDateKeys
      ..clear()
      ..addAll(completionHistory.map(_toDateKey));

    for (final completionDate in completionHistory) {
      _dailyStatus[formatDateKey(completionDate)] = DayStatus.allComplete;
    }

    if (notify) {
      notifyListeners();
    }
  }

  List<Task> getTasksForDate(DateTime? date) {
    if (date == null) return <Task>[];

    final targetDate = DateTime(date.year, date.month, date.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_isSameDate(targetDate, today)) {
      return List<Task>.from(tasks);
    }

    return <Task>[];
  }

  DayStatus? getStatusForDate(DateTime? date) {
    if (date == null) return null;

    final status = _dailyStatus[formatDateKey(date)];
    if (status != null) {
      return status;
    }

    if (_completionHistoryDateKeys.contains(_toDateKey(date))) {
      return DayStatus.allComplete;
    }

    return null;
  }

  DayStatus? getTaskStatusForDate(DateTime date) {
    return getStatusForDate(date);
  }

  void setMood(String mood) {
    if (_isMoodConfirmed) return;

    selectedMood = mood;

    hasNavigatedToStatsToday = false;
    notifyListeners();
  }

  void confirmMood() {
    if (selectedMood != null) {
      generateTasksByMood(selectedMood!);
    }
    _isMoodConfirmed = true;
    notifyListeners();
  }

  void unlockMood() {
    _isMoodConfirmed = false;
    selectedMood = null;
    tasks = [];
    notifyListeners();
  }

  void generateTasksByMood(String mood) {
    if (mood == 'Energetic') {
      tasks = [
        Task(
          id: '1',
          title: '5km Morning Run',
          mood: 'Energetic',
          duration: 30,
        ),
        Task(
          id: '2',
          title: 'Power Yoga Session',
          mood: 'Energetic',
          duration: 45,
        ),
        Task(
          id: '3',
          title: 'Plan Next Week Goals',
          mood: 'Energetic',
          duration: 20,
        ),
      ];
    } else if (mood == 'Normal') {
      tasks = [
        Task(id: '1', title: '15min Brisk Walk', mood: 'Normal', duration: 15),
        Task(id: '2', title: 'Guided Meditation', mood: 'Normal', duration: 10),
        Task(id: '3', title: 'Read 10 Pages', mood: 'Normal', duration: 15),
      ];
    } else if (mood == 'Tired') {
      tasks = [
        Task(id: '1', title: 'Light Stretching', mood: 'Tired', duration: 10),
        Task(id: '2', title: 'Deep Breathing', mood: 'Tired', duration: 5),
        Task(
          id: '3',
          title: 'Listen to Lo-fi Beats',
          mood: 'Tired',
          duration: 15,
        ),
      ];
    }
    updateDayStatus(DateTime.now(), tasks, notify: false);
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = tasks[index];
      tasks[index] = task.copyWith(completed: !task.completed);

      // Update total completed count
      if (task.completed) {
        // Task was just uncompleted
        totalCompleted = (totalCompleted - 1).clamp(0, double.infinity).toInt();
      } else {
        // Task was just completed
        totalCompleted += 1;
      }

      final completed = tasks.where((t) => t.completed).length;

      if (tasks.isEmpty) {
        setDayStatus(DateTime.now(), DayStatus.none);
      } else if (completed == tasks.length) {
        setDayStatus(DateTime.now(), DayStatus.allComplete);
      } else if (completed > 0) {
        setDayStatus(DateTime.now(), DayStatus.someComplete);
      } else {
        setDayStatus(DateTime.now(), DayStatus.inProgress);
      }

      notifyListeners();
    }
  }

  void markAllAsDone() async {
    if (tasks.isEmpty || _currentUserId == null) return;

    bool wasAllCompleted = tasks.every((t) => t.completed);
    int completedCount = 0;

    for (int i = 0; i < tasks.length; i++) {
      if (!tasks[i].completed) {
        tasks[i] = tasks[i].copyWith(completed: true);
        totalCompleted += 1;
        completedCount += 1;
      }
    }

    // Only update streak if tasks were actually completed
    if (completedCount > 0 && !wasAllCompleted) {
      await updateStreak();
    }

    updateDayStatus(DateTime.now(), tasks, notify: false);

    notifyListeners();
  }

  /// Updates the user's streak based on task completion
  /// Should be called after all tasks for the day are completed
  Future<void> updateStreak() async {
    if (_currentUserId == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check if all tasks are completed
    if (!tasks.every((t) => t.completed)) {
      return; // Don't update streak if not all tasks are done
    }

    // Prevent duplicate updates for the same day
    if (user.lastCompletedDate != null) {
      final lastCompleted = DateTime(
        user.lastCompletedDate!.year,
        user.lastCompletedDate!.month,
        user.lastCompletedDate!.day,
      );
      if (lastCompleted == today) {
        return; // Already completed today
      }
    }

    // Record completion in Firestore
    await _userService.recordCompletion(_currentUserId!, today);
    _completionHistoryDateKeys.add(_toDateKey(today));

    // Calculate new streak
    int newStreak = await _calculateStreak(_currentUserId!, today);

    // Update user profile
    user = user.copyWith(dailyStreak: newStreak, lastCompletedDate: today);
    dailyStreak = newStreak;

    // Save to Firestore
    await _userService.updateUserProfile(_currentUserId!, user);
  }

  /// Calculates the current streak based on completion history
  Future<int> _calculateStreak(String uid, DateTime today) async {
    final completionHistory = await _userService.getCompletionHistory(uid);

    if (completionHistory.isEmpty) {
      return 1; // First completion
    }

    // Sort dates in descending order (most recent first)
    completionHistory.sort((a, b) => b.compareTo(a));

    int streak = 1; // Start with today
    DateTime currentDate = today;

    for (final completedDate in completionHistory) {
      final completedDay = DateTime(
        completedDate.year,
        completedDate.month,
        completedDate.day,
      );
      final expectedDate = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day - 1,
      );

      if (completedDay == expectedDate) {
        // Consecutive day
        streak++;
        currentDate = expectedDate;
      } else if (completedDay == currentDate) {
        // Same day, skip
        continue;
      } else {
        // Gap found, streak ends
        break;
      }
    }

    return streak;
  }

  void toggleReminder() async {
    reminderEnabled = !reminderEnabled;
    user = user.copyWith(reminderEnabled: reminderEnabled);
    if (_currentUserId != null) {
      await _userService.updateUserProfile(_currentUserId!, user);
    }
    notifyListeners();
  }

  /// update stored user name (e.g. after auth changes)
  void setUserName(String name) async {
    user = user.copyWith(name: name);
    if (_currentUserId != null) {
      await _userService.updateUserProfile(_currentUserId!, user);
    }
    notifyListeners();
  }

  Future<void> updateProfileName(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty || _currentUserId == null) return;

    user = user.copyWith(name: trimmedName);
    notifyListeners();

    await _userService.updateUserFields(_currentUserId!, {'name': trimmedName});
  }

  Future<void> updateProfilePhoto(XFile image) async {
    if (_currentUserId == null) return;

    final photoUrl = await _userService.uploadProfileImage(
      _currentUserId!,
      image,
    );
    user = user.copyWith(photoUrl: photoUrl);
    notifyListeners();

    await _userService.updateUserFields(_currentUserId!, {
      'photoUrl': photoUrl,
    });
  }

  /// Updates user profile with name and/or email changes
  /// Called from EditProfileScreen when user saves changes
  Future<void> updateUserProfile({String? name, String? email}) async {
    if (_currentUserId == null) return;

    // Update local user object using copyWith
    if (name != null && name.trim().isNotEmpty) {
      user = user.copyWith(name: name.trim());
    }

    // Notify listeners immediately after updating user object
    notifyListeners();

    // Prepare fields to update in Firestore
    final Map<String, dynamic> fieldsToUpdate = {};
    if (name != null && name.trim().isNotEmpty) {
      fieldsToUpdate['name'] = name.trim();
    }
    if (email != null && email.trim().isNotEmpty) {
      fieldsToUpdate['email'] = email.trim();
    }

    // Save to Firestore if there are fields to update
    if (fieldsToUpdate.isNotEmpty) {
      await _userService.updateUserFields(_currentUserId!, fieldsToUpdate);
    }
  }

  bool shouldNavigateToStats() {
    if (tasks.isNotEmpty &&
        tasks.every((t) => t.completed) &&
        !hasNavigatedToStatsToday) {
      hasNavigatedToStatsToday = true;
      return true;
    }
    return false;
  }

  bool get isAllTasksCompleted =>
      tasks.isNotEmpty && tasks.every((t) => t.completed);
}
