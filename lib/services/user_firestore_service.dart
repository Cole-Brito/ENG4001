import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUsername(String userId, String newUsername) async {
    await _firestore.collection('users').doc(userId).update({
      'username': newUsername,
    });
  }

  Future<void> updateNotifications(String userId, bool enabled) async {
    await _firestore.collection('users').doc(userId).update({
      'notificationsEnabled': enabled,
    });
  }
}
