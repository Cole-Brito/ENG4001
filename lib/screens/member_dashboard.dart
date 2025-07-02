/*
* ROSS Game Managment Project
* Author: Cole Brito
* Member dashboard
*/

// lib/screens/member_dashboard.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/mock_game_store.dart';
import 'login_screen.dart';
import '../../models/game.dart';
import '../../models/user.dart';
import 'game_play_screen.dart';
import 'leaderboard_screen.dart';

class MemberDashboard extends StatefulWidget {
  final User user;

  const MemberDashboard({super.key, required this.user});

  @override
  State<MemberDashboard> createState() => _MemberDashboardState();
}

class _MemberDashboardState extends State<MemberDashboard> {
  void _rsvp(Game game) {
    setState(() {
      widget.user.addRsvp(game.date);
      // Add user to game queue if not already there
      if (!game.queue.any((User u) => u.username == widget.user.username)) {
        game.queue.add(widget.user);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You have RSVP’d for the ${game.format} game!'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LoginScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Game> games = MockGameStore.games;
    final String username = widget.user.username;
    final DateTime today = DateTime.now();

    List<Game> todayGames =
        games
            .where(
              (Game g) =>
                  g.date.year == today.year &&
                  g.date.month == today.month &&
                  g.date.day == today.day &&
                  widget.user.hasRsvped(g.date),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome, $username!',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),

            // Display today's game if RSVP'd or actions if not
            if (todayGames.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Today's Game",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'You have an RSVP for today\'s ${todayGames.first.format} game!',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: () {
                          final Game todayGame = todayGames.first;
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder:
                                  (BuildContext context) => GamePlayScreen(
                                    game: todayGame,
                                    currentUser: widget.user,
                                  ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.sports_soccer),
                        label: const Text('View Game In Progress'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder:
                                  (BuildContext context) =>
                                      const LeaderboardScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.leaderboard),
                        label: const Text('View Leaderboard'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "No Game Today",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "No game scheduled for today or you haven't RSVP'd.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder:
                                  (BuildContext context) =>
                                      const LeaderboardScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.leaderboard),
                        label: const Text('View Leaderboard'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 10),
            Text(
              'Upcoming Games:',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),

            // List of available games to RSVP
            Expanded(
              child:
                  games.isEmpty
                      ? Center(
                        child: Text(
                          'No scheduled games available.',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: games.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Game game = games[index];
                          final bool hasRsvped = widget.user.hasRsvped(
                            game.date,
                          );
                          final String dateFormatted = DateFormat(
                            'EEE, MMM d, yyyy',
                          ).format(game.date);

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              title: Text(
                                '${game.format} on $dateFormatted',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              subtitle: Text(
                                'Courts: ${game.courts} | Players: ${game.players}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              trailing: ElevatedButton(
                                onPressed: hasRsvped ? null : () => _rsvp(game),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      hasRsvped
                                          ? Theme.of(
                                            context,
                                          ).colorScheme.primary.withOpacity(0.5)
                                          : Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                  foregroundColor:
                                      hasRsvped
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                              .withOpacity(0.5)
                                          : Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: hasRsvped ? 0 : 3,
                                ),
                                child: Text(hasRsvped ? 'Signed Up' : 'RSVP'),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
