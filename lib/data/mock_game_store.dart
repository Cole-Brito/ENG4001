import '../models/game.dart';

class MockGameStore {
  static final List<Game> _games = [];

  static void addGame(Game game) {
    _games.add(game);
  }

  static List<Game> get games => List.unmodifiable(_games);

  static void clear() {
    _games.clear();
  }
}
