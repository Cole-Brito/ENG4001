// lib/models/user.dart
class User {
  final String username;
  final bool isAdmin;
  final List<DateTime> rsvps;
  final int gamesWon = 0;
  final int gamesPlayed = 0;

  User({required this.username, required this.isAdmin, List<DateTime>? rsvps})
    : rsvps = rsvps ?? [];

  void addRsvp(DateTime gameDate) {
    if (!rsvps.contains(gameDate)) {
      rsvps.add(gameDate);
    }
  }

  bool hasRsvped(DateTime gameDate) {
    return rsvps.contains(gameDate);
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
