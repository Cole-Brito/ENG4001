import 'package:cloud_firestore/cloud_firestore.dart';

class GuestFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveGuest({
    required String username,
    required String email,
  }) async {
    final now = DateTime.now();
    await _firestore.collection('guests').add({
      'username': username,
      'email': email,
      'createdAt': now.toIso8601String(),
      'expiresAt': now.add(const Duration(days: 1)).toIso8601String(),
    });
  }

  Future<void> sendJoinRequest({
    required String username,
    required String email,
    required String gameId,
  }) async {
    await _firestore.collection('guest_requests').doc('${gameId}_$email').set({
      'username': username,
      'email': email,
      'gameId': gameId,
      'requestedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> cancelJoinRequest({
    required String email,
    required String gameId,
  }) async {
    await _firestore
        .collection('guest_requests')
        .doc('${gameId}_$email')
        .delete();
  }

  Future<bool> hasSentRequest({
    required String email,
    required String gameId,
  }) async {
    final doc =
        await _firestore
            .collection('guest_requests')
            .doc('${gameId}_$email')
            .get();
    return doc.exists;
  }

  // Fetch all guest requests from Firestore
  Future<List<Map<String, dynamic>>> fetchAllGuestRequests() async {
    final snapshot = _firestore.collection('guest_requests').get();
    return (await snapshot).docs.map((doc) => doc.data()).toList();
  }
}
