/*
* ROSS Game Managment Project
* Author: Cole Brito
* Member dashboard
*
*/

// lib/screens/member_dashboard.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/mock_game_store.dart';
import 'login_screen.dart';
import '../models/game.dart';
import '../models/user.dart';
import '../game_play_screen.dart';

class MemberDashboard extends StatefulWidget {
  final User user;

  const MemberDashboard({super.key, required this.user});

  @override
  State<MemberDashboard> createState() => _MemberDashboardState();
}

class _MemberDashboardState extends State<MemberDashboard> {
  //Method for signing up for games
  //takes a "game" obj as the game the member is signing up for
  void _rsvp(Game game) {
    setState(() {
      widget.user.addRsvp(game.date);
      if (!game.queue.any((u) => u.username == widget.user.username)) {
        game.queue.add(widget.user);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have RSVP’d for the ${game.format} game!')),
    );
  }

  //Logout function
  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  //----------- UI CODE BELOW ---------------

  @override
  Widget build(BuildContext context) {
    final games = MockGameStore.games;
    final username = widget.user.username;
    final today = DateTime.now();

    // Filter games for today that the member has RSVP'd for
    List<Game> todayGames =
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $username!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Display today's game if RSVP'd
            const Text(
              'Today\'s Game',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (todayGames.isNotEmpty)
              Card(
                elevation: 3,
                child: ListTile(
                  title: Text('${todayGames.first.format} Game In Progress'),
                  subtitle: Text(
                    DateFormat(
                      'EEE, MMM d, yyyy',
                    ).format(todayGames.first.date),
                  ),
                  trailing: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Enter'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => GamePlayScreen(
                                game: todayGames.first,
                                currentUser: widget.user,
                              ),
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              const Text(
                "No game scheduled for today or you haven't RSVP'd.",
                style: TextStyle(color: Colors.grey),
              ),

            const SizedBox(height: 32),

            // List of available games to RSVP
            const Text(
              'Upcoming Games',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child:
                  games.isEmpty
                      ? const Center(
                        child: Text('No scheduled games available.'),
                      )
                      : ListView.builder(
                        itemCount: games.length,
                        itemBuilder: (context, index) {
                          final game = games[index];
                          final hasRsvped = widget.user.hasRsvped(game.date);
                          final dateFormatted = DateFormat(
                            'EEE, MMM d, yyyy',
                          ).format(game.date);

                          //Might be worth it to change this to a card
                          //that can be tapped, which will then bring up
                          //a list of options
                          // https://api.flutter.dev/flutter/material/Card-class.html
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text('${game.format} Game'),
                              subtitle: Text(
                                'Date: $dateFormatted\n'
                                'Courts: ${game.courts} | Players: ${game.players}',
                              ),
                              trailing: ElevatedButton(
                                onPressed: hasRsvped ? null : () => _rsvp(game),
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
