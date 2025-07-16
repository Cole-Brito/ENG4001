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

  /// Add this method:
  Game copyWith({
    String? format,
    DateTime? date,
    int? courts,
    int? players,
    List<User>? rsvps,
    List<User>? queue,
    List<List<User>>? matches,
    List<List<User>>? waitingGroups,
    Map<int, Match>? activeMatches,
  }) {
    return Game(
      format: format ?? this.format,
      date: date ?? this.date,
      courts: courts ?? this.courts,
      players: players ?? this.players,
      rsvps: rsvps ?? this.rsvps,
      queue: queue ?? this.queue,
      matches: matches ?? this.matches,
      waitingGroups: waitingGroups ?? this.waitingGroups,
      activeMatches: activeMatches ?? this.activeMatches,
    );
  }
}
