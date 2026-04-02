import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
          photoUrl: data['photoUrl'] as String?,
          lastCompletedDate: data['lastCompletedDate'] != null
              ? DateTime.fromMillisecondsSinceEpoch(data['lastCompletedDate'])
              : null,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
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
        'photoUrl': profile.photoUrl,
        'lastCompletedDate': profile.lastCompletedDate?.millisecondsSinceEpoch,
      });
    } catch (e) {
      debugPrint('Error updating user profile: $e');
    }
  }

  Future<void> updateUserFields(String uid, Map<String, dynamic> fields) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .set(fields, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error updating user fields: $e');
      rethrow;
    }
  }

  Future<String> uploadProfileImage(String uid, XFile image) async {
    try {
      final data = await image.readAsBytes();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('users/$uid/profile/$fileName');

      final metadata = SettableMetadata(contentType: 'image/jpeg');
      await ref.putData(data, metadata);

      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading profile image: $e');
      rethrow;
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
        'photoUrl': null,
        'lastCompletedDate': null,
      });
    } catch (e) {
      debugPrint('Error creating user profile: $e');
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
      debugPrint('Error getting completion history: $e');
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
      debugPrint('Error recording completion: $e');
    }
  }
}
