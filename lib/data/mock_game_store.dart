import '../models/game.dart';
import '../models/user.dart';

class MockGameStore {
  //Test game
  static List<Game> _games = [testGame];

  // temp function to update a game, this will be moved later - Cole
  static void updateGame(Game oldGame, Game updatedGame) {
    final index = _games.indexOf(oldGame);
    if (index != -1) {
      _games[index] = updatedGame;
    }
  }

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
}
