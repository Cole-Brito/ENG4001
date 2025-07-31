/*
*
* Author: Cole Brito
* UI Author : Bivin Job
* Admin dashboard
*
*/

// lib/screens/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'create_game_screen.dart';
import 'login_screen.dart';
import 'leaderboard_screen.dart';
import 'create_season_screen.dart';
import '../../data/mock_game_store.dart';
import '../../models/game.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LoginScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void _showEditDialog(BuildContext context, Game game) {
    final courtsController = TextEditingController(
      text: game.courts.toString(),
    );
    final playersController = TextEditingController(
      text: game.players.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${game.format} Game'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Scheduled for ${DateFormat.yMMMd().format(game.date)}'),
              const SizedBox(height: 12),
              TextField(
                controller: courtsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Courts',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: playersController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Players',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newCourts = int.tryParse(courtsController.text);
                final newPlayers = int.tryParse(playersController.text);

                if (newCourts != null && newPlayers != null) {
                  final updatedGame = game.copyWith(
                    courts: newCourts,
                    players: newPlayers,
                  );

                  MockGameStore.updateGame(game, updatedGame);

                  setState(() {}); // Refresh UI after update
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final games = MockGameStore.games;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.indigo.shade50,
        elevation: 4,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome, Admin!',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 32),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                _AdminDashboardActionCard(
                  icon: Icons.event_note,
                  title: 'Create New Game',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder:
                            (BuildContext context) => const CreateGameScreen(),
                      ),
                    );
                  },
                ),
                _AdminDashboardActionCard(
                  icon: Icons.leaderboard,
                  title: 'View Leaderboard',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder:
                            (BuildContext context) => const LeaderboardScreen(),
                      ),
                    );
                  },
                ),
                _AdminDashboardActionCard(
                  icon: Icons.edit_calendar_outlined,
                  title: 'Create Season',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder:
                            (BuildContext context) =>
                                const CreateSeasonScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Scheduled Games',
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  games.isEmpty
                      ? const Center(child: Text('No games scheduled yet.'))
                      : ListView.builder(
                        itemCount: games.length,
                        itemBuilder: (context, index) {
                          final game = games[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            leading: const Icon(Icons.sports),
                            title: Text(
                              '${game.format} on ${DateFormat.yMMMd().format(game.date)}',
                            ),
                            subtitle: Text(
                              'Courts: ${game.courts}, Players: ${game.players}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showEditDialog(context, game),
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

class _AdminDashboardActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AdminDashboardActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
