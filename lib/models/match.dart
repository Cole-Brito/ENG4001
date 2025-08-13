import 'user.dart';

class Match {
  final List<User> players;
  /*
  This will be used later on for match tracking and automation purposes
  i.e. We can have the match be time limited or track how long each match
  goes for.
  */
  final DateTime startTime;

  Match({required this.players, required this.startTime});
}
