import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user profile from Firestore
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        return UserProfile(
          name: data['name'] ?? 'User',
          dailyStreak: data['dailyStreak'] ?? 0,
          totalTasks: data['totalTasks'] ?? 0,
          reminderEnabled: data['reminderEnabled'] ?? true,
          lastCompletedDate: data['lastCompletedDate'] != null
              ? DateTime.fromMillisecondsSinceEpoch(data['lastCompletedDate'])
              : null,
        );
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Update user profile in Firestore
  Future<void> updateUserProfile(String uid, UserProfile profile) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'name': profile.name,
        'dailyStreak': profile.dailyStreak,
        'totalTasks': profile.totalTasks,
        'reminderEnabled': profile.reminderEnabled,
        'lastCompletedDate': profile.lastCompletedDate?.millisecondsSinceEpoch,
      });
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  // Create user profile in Firestore (on registration)
  Future<void> createUserProfile(String uid, String name) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'dailyStreak': 0,
        'totalTasks': 0,
        'reminderEnabled': true,
        'lastCompletedDate': null,
      });
    } catch (e) {
      print('Error creating user profile: $e');
    }
  }

  // Get completion history for streak calculation
  Future<List<DateTime>> getCompletionHistory(String uid) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('completions')
          .orderBy('date', descending: true)
          .limit(30) // Last 30 days
          .get();

      return querySnapshot.docs
          .map((doc) => DateTime.fromMillisecondsSinceEpoch(doc['date']))
          .toList();
    } catch (e) {
      print('Error getting completion history: $e');
      return [];
    }
  }

  // Record completion for today
  Future<void> recordCompletion(String uid, DateTime date) async {
    try {
      final dateKey = DateTime(
        date.year,
        date.month,
        date.day,
      ).millisecondsSinceEpoch;
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('completions')
          .doc(dateKey.toString())
          .set({'date': dateKey, 'completed': true});
    } catch (e) {
      print('Error recording completion: $e');
    }
  }
}
