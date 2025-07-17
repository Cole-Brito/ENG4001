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

  // The following code will be used when we add the leader board feature and user profile screen
  // Currently I cant be bothered to make it work
  // - Cole :)

  // get totalGamesPlayed(int games) {
  //   this.gamesPlayed = games;
  //   return gamesPlayed;
  // }

  // get totalGamesWon(int games) {
  //   this.gamesWon = games;
  //   if (games < 0) {
  //     throw ArgumentError('Total games won cannot be negative');
  //   }
  //   return gamesWon;
  // }

  // set totalGamesPlayed(int value) {
  //   // This setter is not used in the current implementation
  // }

  // set totalGamesWon(int value) {
  //   // This setter is not used in the current implementation
  // }
}
