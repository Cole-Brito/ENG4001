/*
*
* Author: Cole Brito
* UI Author : Bivin Job
* Edited by: Jean Luc
* Admin dashboard
*
*/

// lib/screens/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import 'user_profile_screen.dart';
import 'create_game_screen.dart';
import 'login_screen.dart';
import 'leaderboard_screen.dart';
import 'create_season_screen.dart';
import '../../data/mock_game_store.dart';
import '../../models/game.dart';

class AdminDashboard extends StatefulWidget {
  final User user;
  const AdminDashboard({super.key, required this.user});

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
            // Delete button
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: const Text('Delete Game'),
                        content: const Text(
                          'Are you sure you want to delete this game? This action cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              MockGameStore.deleteGame(game);
                              setState(() {});
                              Navigator.pop(ctx); // close confirm
                              Navigator.pop(context); // close edit
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                );
              },
              child: const Text('Delete'),
            ),
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
        title: Text(
          'Welcome, ${widget.user.username}!',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF10138A), // ROS Blue
        elevation: 4,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserProfileScreen(user: widget.user),
                    ),
                  );
                  break;
                case 'notifications':
                  // Add Functionality here when bivin pushes
                  break;
                case 'createGame':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateGameScreen()),
                  );
                  break;
                case 'leaderboard':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LeaderboardScreen(),
                    ),
                  );
                  break;
                case 'season':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateSeasonScreen(),
                    ),
                  );
                  break;
                case 'settings':
                  // Add Functionality here when bivin pushes
                  break;
                case 'logout':
                  _logout(context);
                  break;
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: Row(
                      children: const [
                        Icon(Icons.person, color: Colors.grey),
                        SizedBox(width: 10),
                        Text('Profile'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'notifications',
                    child: Row(
                      children: const [
                        Icon(Icons.notifications, color: Colors.grey),
                        SizedBox(width: 10),
                        Text('Notifications'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'createGame',
                    child: Row(
                      children: const [
                        Icon(Icons.add_box, color: Colors.grey),
                        SizedBox(width: 10),
                        Text('Create Game'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'leaderboard',
                    child: Row(
                      children: const [
                        Icon(Icons.leaderboard, color: Colors.grey),
                        SizedBox(width: 10),
                        Text('Leaderboard'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'season',
                    child: Row(
                      children: const [
                        Icon(Icons.edit_calendar, color: Colors.grey),
                        SizedBox(width: 10),
                        Text('Create Season'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'settings',
                    child: Row(
                      children: const [
                        Icon(Icons.settings, color: Colors.grey),
                        SizedBox(width: 10),
                        Text('Settings'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: const [
                        Icon(Icons.logout, color: Colors.redAccent),
                        SizedBox(width: 10),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                          final dateStr = DateFormat(
                            'EEE, MMM d, yyyy',
                          ).format(game.date);

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${game.format} • $dateStr',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Courts: ${game.courts} | Players: ${game.players}',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          ElevatedButton.icon(
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 16,
                                            ),
                                            label: const Text('Edit'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.grey.shade700,
                                              foregroundColor: Colors.white,
                                            ),
                                            onPressed:
                                                () => _showEditDialog(
                                                  context,
                                                  game,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 100,
          width: 100,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
