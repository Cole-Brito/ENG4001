import 'game.dart';

class User {
  final String username;
  final bool isAdmin;

  // RSVP list of full Game objects
  final List<Game> rsvps;

  // Leaderboard scoring field
  int gamesPlayed;

  User({
    required this.username,
    required this.isAdmin,
    List<Game>? rsvps,
    this.gamesPlayed = 0, // Default value
  }) : rsvps = rsvps ?? [];

  void addRsvp(Game game) {
    if (!rsvps.contains(game)) {
      rsvps.add(game);
    }
  }

  void removeRsvp(Game game) {
    rsvps.remove(game);
  }

  bool hasRsvped(Game game) {
    return rsvps.contains(game);
  }

  // Check if RSVP exists by date
  bool hasRsvpedOnDate(DateTime date) {
    return rsvps.any(
      (g) =>
          g.date.year == date.year &&
          g.date.month == date.month &&
          g.date.day == date.day,
    );
  }

  // Get all games RSVP’d on a specific date
  List<Game> rsvpedGamesOnDate(DateTime date) {
    return rsvps
        .where(
          (g) =>
              g.date.year == date.year &&
              g.date.month == date.month &&
              g.date.day == date.day,
        )
        .toList();
  }
}
