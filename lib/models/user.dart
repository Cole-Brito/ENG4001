// lib/models/user.dart
import 'game.dart';

class User {
  final String username;
  final bool isAdmin;

  // Changed from List<DateTime> to List<Game>
  final List<Game> rsvps;

  User({required this.username, required this.isAdmin, List<Game>? rsvps})
    : rsvps = rsvps ?? [];

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

  // Optionally check if RSVP exists by just date
  bool hasRsvpedOnDate(DateTime date) {
    return rsvps.any(
      (g) =>
          g.date.year == date.year &&
          g.date.month == date.month &&
          g.date.day == date.day,
    );
  }

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
