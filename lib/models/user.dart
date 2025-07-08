// lib/models/user.dart

class User {
  final String username;
  final bool isAdmin;

  // Stores the list of RSVP’d game dates
  final List<DateTime> rsvps;

  User({required this.username, required this.isAdmin, List<DateTime>? rsvps})
    : rsvps = rsvps ?? [];

  /// Add an RSVP if not already added
  void addRsvp(DateTime gameDate) {
    if (!hasRsvped(gameDate)) {
      rsvps.add(gameDate);
    }
  }

  /// Remove an RSVP for a given date
  void removeRsvp(DateTime gameDate) {
    rsvps.removeWhere(
      (date) =>
          date.year == gameDate.year &&
          date.month == gameDate.month &&
          date.day == gameDate.day,
    );
  }

  /// Check if the user has RSVP’d for a specific date
  bool hasRsvped(DateTime gameDate) {
    return rsvps.any(
      (date) =>
          date.year == gameDate.year &&
          date.month == gameDate.month &&
          date.day == gameDate.day,
    );
  }
}
