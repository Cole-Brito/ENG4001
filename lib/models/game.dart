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
  List<String>? pendingRequests;

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
    List<String>? pendingRequests,
  }) : rsvps = rsvps ?? [],
       queue = queue ?? [],
       matches = matches ?? [],
       waitingGroups = waitingGroups ?? [],
       activeMatches = activeMatches ?? {},
       pendingRequests = pendingRequests ?? [];
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
    List<String>? pendingRequests,
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
      pendingRequests: pendingRequests ?? this.pendingRequests,
    );
  }

  static Map<String, int> leaderboard = {};
  static Map<String, int> gamesPlayed = {};
}
