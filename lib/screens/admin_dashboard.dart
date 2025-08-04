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
      MaterialPageRoute<void>(builder: (context) => const LoginScreen()),
      (route) => false,
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
                decoration: const InputDecoration(labelText: 'Courts'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: playersController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Players'),
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
                  setState(() {});
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

  void _showGuestRequests(BuildContext context) {
    final games = MockGameStore.games;
    final guestRequests = <Map<String, dynamic>>[];

    for (final game in games) {
      for (final guest in game.pendingRequests ?? []) {
        guestRequests.add({'guest': guest, 'game': game});
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Guest Join Requests'),
          content:
              guestRequests.isEmpty
                  ? const Text('No guest join requests at the moment.')
                  : SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: guestRequests.length,
                      itemBuilder: (context, index) {
                        final request = guestRequests[index];
                        final Game game = request['game'];
                        final String guest = request['guest'];

                        return ListTile(
                          title: Text(
                            '$guest requested to join ${game.format}',
                          ),
                          subtitle: Text(
                            'Date: ${DateFormat.yMMMd().format(game.date)}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  game.queue.add(
                                    User(username: guest, isAdmin: false),
                                  );
                                  game.pendingRequests?.remove(guest);
                                  setState(() {});
                                  Navigator.pop(context);
                                  _showGuestRequests(
                                    context,
                                  ); // reopen to refresh
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  game.pendingRequests?.remove(guest);
                                  setState(() {});
                                  Navigator.pop(context);
                                  _showGuestRequests(
                                    context,
                                  ); // reopen to refresh
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final games = MockGameStore.games;
    int totalGuestRequests = games.fold(
      0,
      (count, game) => count + (game.pendingRequests?.length ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.user.username}!'),
        backgroundColor: const Color(0xFF10138A),
        centerTitle: true,
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
                case 'guestRequests':
                  _showGuestRequests(context);
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // disable its own scroll
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _AdminDashboardActionCard(
                  icon: Icons.event_note,
                  title: 'Create New Game',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateGameScreen(),
                        ),
                      ),
                ),
                _AdminDashboardActionCard(
                  icon: Icons.leaderboard,
                  title: 'View Leaderboard',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LeaderboardScreen(),
                        ),
                      ),
                ),
                _AdminDashboardActionCard(
                  icon: Icons.edit_calendar,
                  title: 'Create Season',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateSeasonScreen(),
                        ),
                      ),
                ),
                _AdminDashboardActionCard(
                  icon: Icons.group_add,
                  title: 'Guest Requests ($totalGuestRequests)',
                  onTap: () => _showGuestRequests(context),
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
            ...games.map((game) {
              final dateStr = DateFormat('EEE, MMM d, yyyy').format(game.date);
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${game.format} • $dateStr'),
                                const SizedBox(height: 4),
                                Text(
                                  'Courts: ${game.courts} | Players: ${game.players}',
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade700,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _showEditDialog(context, game),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
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
              children: [
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
