import 'game.dart';

class User {
  final String username;
  final bool isAdmin;
  final bool isGuest;
  final String? email;
  final List<Game> rsvps;
  int gamesPlayed;

  User({
    required this.username,
    required this.isAdmin,
    this.isGuest = false,
    this.email,
    List<Game>? rsvps,
    this.gamesPlayed = 0,
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
