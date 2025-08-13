import '../models/game.dart';
import '../models/user.dart';

class MockGameStore {
  // temp function to update a game, this will be moved later - Cole
  static void updateGame(Game oldGame, Game updatedGame) {
    final index = _games.indexOf(oldGame);
    if (index != -1) {
      _games[index] = updatedGame;
    }
  }

  // A method to delete games
  static void deleteGame(Game game) {
    _games.remove(game);
  }

  // A list of fake users for testing
  static final List<User> testUsers = List.generate(
    11,
    (i) => User(
      username: 'player${i + 1}',
      isAdmin: false,
      email: 'player${i + 1}@fake.com', // Add fake email for test users
      gamesPlayed: (i + 1), // Just to simulate leaderboard points
    ),
  );

  static final List<Game> _games = [
    Game(
      format: 'Badminton',
      date: DateTime.now(),
      startTime: DateTime.now().add(
        const Duration(hours: 2),
      ), // Game starts 2 hours from now
      courts: 2,
      players: 12,
      rsvps: List.from(testUsers),
      queue: List.from(testUsers),
    ),
    Game(
      format: 'Tennis',
      date: DateTime.now(),
      startTime: DateTime.now().add(
        const Duration(hours: 4),
      ), // Game starts 4 hours from now
      courts: 2,
      players: 12,
      rsvps: List.from(testUsers),
      queue: List.from(testUsers),
    ),
    Game(
      format: 'Table Tennis',
      date: DateTime.now(),
      startTime: DateTime.now().add(
        const Duration(hours: 6),
      ), // Game starts 6 hours from now
      courts: 1,
      players: 4,
      rsvps: List.from(testUsers),
      queue: List.from(testUsers),
    ),
  ];

  static void addGame(Game game) {
    _games.add(game);
  }

  static List<Game> get games => List.unmodifiable(_games);

  static void clear() {
    _games.clear();
  }
}
