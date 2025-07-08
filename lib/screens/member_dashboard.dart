/*
* ROSS Game Management Project
* Author: Cole Brito
* UI Author : Bivin Job
* Member dashboard
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/mock_game_store.dart';
import '../../models/game.dart';
import '../../models/user.dart';
import 'login_screen.dart';
import 'game_play_screen.dart';
import 'leaderboard_screen.dart';

class MemberDashboard extends StatefulWidget {
  final User user;

  const MemberDashboard({super.key, required this.user});

  @override
  State<MemberDashboard> createState() => _MemberDashboardState();
}

class _MemberDashboardState extends State<MemberDashboard> {
  // Returns correct banner image for a game format
  String _imageForFormat(String format) {
    switch (format.toLowerCase()) {
      case 'tennis':
        return 'assets/images/Tennis Court.png';
      case 'table tennis':
        return 'assets/images/Table Tennis.png';
      case 'badminton':
      default:
        return 'assets/images/Badminton Court.png';
    }
  }

  // RSVP logic (unchanged)
  void _rsvp(Game game) {
    setState(() {
      widget.user.addRsvp(game.date);
      if (!game.queue.any((u) => u.username == widget.user.username)) {
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
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Game> games = MockGameStore.games;
    final String username = widget.user.username;
    final DateTime today = DateTime.now();

    final List<Game> todayGames =
        games
            .where(
              (g) =>
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
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $username!',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // ── Today's Game Card (with banner) ──
            if (todayGames.isNotEmpty)
              _todayGameCard(todayGames.first)
            else
              _noGameTodayCard(),

            const SizedBox(height: 10),
            Text(
              'Upcoming Games:',
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // ── Upcoming Games List (each with banner) ──
            Expanded(
              child:
                  games.isEmpty
                      ? Center(
                        child: Text(
                          'No scheduled games available.',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: games.length,
                        itemBuilder:
                            (_, index) => _upcomingGameCard(games[index]),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Widgets ----------

  /// Card for today's RSVP'd game
  Widget _todayGameCard(Game game) {
    final dateFormatted = DateFormat('EEE, MMM d, yyyy').format(game.date);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          // Banner image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              _imageForFormat(game.format),
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Details & actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Game",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'You have RSVP’d for $dateFormatted\nGame: ${game.format}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  icon: const Icon(Icons.sports_soccer_rounded),
                  label: const Text('View Game In Progress'),
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => GamePlayScreen(
                                game: game,
                                currentUser: widget.user,
                              ),
                        ),
                      ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  icon: const Icon(Icons.leaderboard),
                  label: const Text('View Leaderboard'),
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LeaderboardScreen(),
                        ),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card shown when there is no game today
  Widget _noGameTodayCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "No Game Today",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "No game scheduled for today or you haven't RSVP'd.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.leaderboard),
              label: const Text('View Leaderboard'),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LeaderboardScreen(),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Card for each upcoming game with banner + RSVP
  Widget _upcomingGameCard(Game game) {
    final hasRsvped = widget.user.hasRsvped(game.date);
    final dateFormatted = DateFormat('EEE, MMM d, yyyy').format(game.date);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              _imageForFormat(game.format),
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${game.format} on $dateFormatted',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Courts: ${game.courts} | Players: ${game.players}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: hasRsvped ? null : () => _rsvp(game),
                  child: Text(hasRsvped ? 'Signed Up' : 'RSVP'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
