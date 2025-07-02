import 'user.dart';

class Match {
  final List<User> players;
  final DateTime startTime;

  Match({required this.players, required this.startTime});
}

class Game {
  final String format;
  final DateTime date;
  final int courts;
  final int players;
  final List<User> rsvps;
  final List<User> queue;
  final List<List<User>> matches;
  final List<List<User>> waitingGroups;
  // This will be used if we can have a map of the courts -- i.e. the admin will be able to assgin the courts numbers
  // int = court number
  final Map<int, Match> activeMatches;

  Game({
    required this.format,
    required this.date,
    required this.courts,
    required this.players,
    List<User>? rsvps,
    List<User>? queue,
    List<List<User>>? matches,
    List<List<User>>? waitingGroups,
    Map<int, Match>? activeMatches,
  }) : rsvps = rsvps ?? [],
       queue = queue ?? [],
       matches = matches ?? [],
       waitingGroups = waitingGroups ?? [],
       activeMatches = activeMatches ?? {};
}
