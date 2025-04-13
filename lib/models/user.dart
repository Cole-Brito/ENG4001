// lib/models/user.dart
class User {
  final String username;
  final bool isAdmin;
  final List<DateTime> rsvps;

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
}
