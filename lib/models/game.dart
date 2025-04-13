// lib/models/game.dart

import 'user.dart';

class Game {
  final String format; // e.g., "Badminton"
  final DateTime date;
  final int courts; // number of courts avalible
  final int players; // number of players expected
  final List<User> rsvps;
  final List<User> queue;
  final List<List<User>> matches;

  Game({
    required this.format,
    required this.date,
    required this.courts,
    required this.players,
    List<User>? rsvps,
    List<User>? queue,
    List<List<User>>? matches,
  }) : rsvps = rsvps ?? [],
       queue = queue ?? [],
       matches = matches ?? [];
}
