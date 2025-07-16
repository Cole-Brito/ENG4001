import '../models/game.dart';
import '../models/user.dart';

class MockGameStore {
  static final List<User> testUsers = List.generate(
    11,
    (i) => User(
      username: 'player${i + 1}',
      isAdmin: false,
      gamesPlayed: (i + 1), // Just to simulate leaderboard points
    ),
  );

  static final List<Game> _games = [
    Game(
      format: 'Badminton',
      date: DateTime.now(),
      courts: 2,
      players: 12,
      rsvps: List.from(testUsers),
      queue: List.from(testUsers),
    ),
    Game(
      format: 'Tennis',
      date: DateTime.now(),
      courts: 2,
      players: 12,
      rsvps: List.from(testUsers),
      queue: List.from(testUsers),
    ),
    Game(
      format: 'Table Tennis',
      date: DateTime.now(),
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
