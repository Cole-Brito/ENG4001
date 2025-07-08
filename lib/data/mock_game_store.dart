import '../models/game.dart';
import '../models/user.dart';

class MockGameStore {
  static final List<Game> _games = [testGame];

  // A list of fake users for testing
  static final List<User> testUsers = List.generate(
    11,
    (i) => User(username: 'player${i + 1}', isAdmin: false),
  );

  static void addGame(Game game) {
    _games.add(game);
  }

  static List<Game> get games => List.unmodifiable(_games);

  static void clear() {
    _games.clear();
  }

  // A fake game for testing purposes
  static final Game testGame = Game(
    format: 'Badminton',
    date: DateTime.now(),
    courts: 2,
    players: 12,
    rsvps: List.from(testUsers),
    queue: List.from(testUsers),
  );

  // A fake game for testing purposes
  static final Game testGame2 = Game(
    format: 'Tennis',
    date: DateTime.now(),
    courts: 2,
    players: 12,
    rsvps: List.from(testUsers),
    queue: List.from(testUsers),
  );

  // A fake game for testing purposes
  static final Game testGame3 = Game(
    format: 'Table Tennis',
    date: DateTime.now(),
    courts: 1,
    players: 4,
    rsvps: List.from(testUsers),
    queue: List.from(testUsers),
  );
}
