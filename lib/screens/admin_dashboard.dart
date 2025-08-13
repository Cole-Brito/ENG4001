import '../services/guest_firestore_service.dart';
import 'game_play_screen.dart';
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
import 'settings_screen.dart';
import 'about_screen.dart';
import 'notifications_screen.dart';
import '../../data/mock_game_store.dart';
import '../../models/game.dart';

class AdminDashboard extends StatefulWidget {
  final User user;
  const AdminDashboard({super.key, required this.user});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late String _adminUsername;

  @override
  void initState() {
    super.initState();
    _adminUsername = widget.user.username;
  }

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
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(game.startTime);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
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
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Start Time:'),
                      const SizedBox(width: 12),
                      Text(selectedTime.format(context)),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          backgroundColor: const Color(0xFF10138A),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (picked != null) {
                            setStateDialog(() {
                              selectedTime = picked;
                            });
                          }
                        },
                        child: const Text('Edit'),
                      ),
                    ],
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
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10138A), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      final newCourts = int.tryParse(courtsController.text);
                      final newPlayers = int.tryParse(playersController.text);
                      if (newCourts != null && newPlayers != null) {
                        final newStartTime = DateTime(
                          game.startTime.year,
                          game.startTime.month,
                          game.startTime.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        final updatedGame = game.copyWith(
                          courts: newCourts,
                          players: newPlayers,
                          startTime: newStartTime,
                        );
                        MockGameStore.updateGame(game, updatedGame);
                        setState(() {});
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showGuestRequests(BuildContext context) {
    final games = MockGameStore.games;
    final guestRequests = <Map<String, dynamic>>[];

    // Fetch guest requests from Firestore and merge into games' pendingRequests
    GuestFirestoreService().fetchAllGuestRequests().then((firestoreRequests) {
      // Clear all pendingRequests in memory
      for (final game in games) {
        game.pendingRequests?.clear();
      }
      // Add requests from Firestore to the correct game's pendingRequests
      for (final req in firestoreRequests) {
        final String gameId = req['gameId'] ?? '';
        final String username = req['username'] ?? '';
        final String email = req['email'] ?? '';
        for (final game in games) {
          final localGameId =
              '${game.format}_${game.date.toIso8601String()}_${game.startTime.toIso8601String()}';
          if (gameId == localGameId) {
            if (!game.pendingRequests!.contains('$username ($email)')) {
              game.pendingRequests!.add('$username ($email)');
            }
          }
        }
      }
      // Now build the guestRequests list for UI
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

                          // Try to parse guest info if in format 'username (email)'
                          String guestName = guest;
                          String? guestEmail;
                          final match = RegExp(
                            r'^(.*) \((.*)\) ?$',
                          ).firstMatch(guest);
                          if (match != null) {
                            guestName = match.group(1) ?? guest;
                            guestEmail = match.group(2);
                          }

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
                                  onPressed: () async {
                                    // Add guest user to the queue with correct info
                                    game.queue.add(
                                      User(
                                        username: guestName,
                                        isAdmin: false,
                                        isGuest: true,
                                        email: guestEmail ?? '',
                                      ),
                                    );
                                    game.pendingRequests?.remove(guest);
                                    // Remove from Firestore
                                    await GuestFirestoreService().cancelJoinRequest(
                                      email: guestEmail ?? '',
                                      gameId:
                                          '${game.format}_${game.date.toIso8601String()}_${game.startTime.toIso8601String()}',
                                    );
                                    if (!mounted) return;
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
                                  onPressed: () async {
                                    game.pendingRequests?.remove(guest);
                                    // Remove from Firestore
                                    await GuestFirestoreService().cancelJoinRequest(
                                      email: guestEmail ?? '',
                                      gameId:
                                          '${game.format}_${game.date.toIso8601String()}_${game.startTime.toIso8601String()}',
                                    );
                                    if (!mounted) return;
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
    });
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
        title: Text(
          'Welcome, ${widget.user.username}!',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10138A), Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            ),
          ),
        ),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 8,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserProfileScreen(user: widget.user),
                  ),
                );
              } else if (value == 'guestRequests') {
                _showGuestRequests(context);
              } else if (value == 'createGame') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateGameScreen()),
                );
              } else if (value == 'leaderboard') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
                );
              } else if (value == 'season') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateSeasonScreen()),
                );
              } else if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => SettingsScreen(
                          username: _adminUsername,
                          notificationsEnabled: true,
                          onUsernameChanged: (newUsername) {
                            setState(() {
                              _adminUsername = newUsername;
                            });
                          },
                          onNotificationsChanged: (enabled) {
                            // Implement notification toggle logic if needed
                          },
                        ),
                  ),
                );
              } else if (value == 'notifications') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              } else if (value == 'about') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              } else if (value == 'logout') {
                _logout(context);
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
                    value: 'settings',
                    child: Row(
                      children: const [
                        Icon(Icons.settings, color: Colors.grey),
                        SizedBox(width: 10),
                        Text('Settings'),
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
                    value: 'about',
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline, color: Colors.grey),
                        SizedBox(width: 10),
                        Text('About'),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFF), Color(0xFFE8F4FD)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // disable its own scroll
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
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
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF10138A), Color(0xFF1E3A8A)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.event_note,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Scheduled Games',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ...games.map((game) {
                final dateStr = DateFormat(
                  'EEE, MMM d, yyyy',
                ).format(game.date);
                final timeStr = DateFormat('h:mm a').format(game.startTime);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => GamePlayScreen(
                              game: game,
                              currentUser: widget.user,
                            ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.08),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.asset(
                            _imageForFormat(game.format),
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF10138A),
                                                Color(0xFF3B82F6),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            game.format.toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '$dateStr  |  $timeStr',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E3A8A),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Courts: ${game.courts} | Players: ${game.players}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF10138A),
                                      Color(0xFF3B82F6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed:
                                      () => _showEditDialog(context, game),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10138A), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 28, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
