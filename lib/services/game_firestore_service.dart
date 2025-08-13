import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game.dart';

class GameFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save a new game in the top-level 'games' collection
  Future<void> addGame({
    required Game game,
    String? createdBy, // Optionally track who created the game
  }) async {
    final gameData = {
      'format': game.format,
      'date': game.date.toIso8601String(),
      'startTime': game.startTime.toIso8601String(),
      'courts': game.courts,
      'players': game.players,
      if (createdBy != null) 'createdBy': createdBy,
      // Add more fields as needed
    };
    await _firestore.collection('games').add(gameData);
  }

  /// Fetch all games from the top-level 'games' collection
  Future<List<Game>> fetchAllGames() async {
    final snapshot = await _firestore.collection('games').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Game(
        format: data['format'],
        date: DateTime.parse(data['date']),
        startTime: DateTime.parse(data['startTime']),
        courts: data['courts'],
        players: data['players'],
      );
    }).toList();
  }
}
