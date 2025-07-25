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
import 'user_profile_screen.dart';
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

  // RSVP logic (unchanged but message improved) // NEW
  void _rsvp(Game game) {
    setState(() {
      widget.user.addRsvp(game);
      if (!game.queue.any((u) => u.username == widget.user.username)) {
        game.queue.add(widget.user);
      }
    });

    final String dateStr = DateFormat('EEE, MMM d').format(game.date); // NEW
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Signed up for ${game.format} • $dateStr', style: TextStyle(color: Colors.white),
      ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
    ),
    );
  }

  // Un-RSVP with confirmation dialog // NEW
  void _unsign(Game game) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Cancel?'),
            content: Text('Remove your RSVP for the ${game.format} game?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Yes',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      setState(() {
        widget.user.removeRsvp(game); // <- must exist in User model
        game.queue.removeWhere(
          (u) => u.username == widget.user.username,
        ); // pull from queue
      });

      final String dateStr = DateFormat('EEE, MMM d').format(game.date);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Un-RSVP’d from ${game.format} • $dateStr'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  // ---------------- existing helpers ----------------
  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  // ---------------- main build ----------------------
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
                  widget.user.hasRsvped(g),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MEMBER DASHBOARD',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: Colors.white,),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF10138A), // ROS Blue
        elevation: 4,     
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, // Menu icon on top-right
            color: Colors.white,),
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              } else if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserProfileScreen(user: widget.user),
                  ),
                );
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

      // -------- Requirement 1: full-page scroll --------------
      body: SingleChildScrollView(
        // NEW
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- greeting ----------
              Text(
                'Welcome, $username!',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
              ),
              const SizedBox(height: 20),

              // ---------- Today’s games (0-n cards) ----------
              if (todayGames.isNotEmpty)
                ...todayGames.map(_todayGameCard) // NEW: show all
              else
                _noGameTodayCard(),

              const SizedBox(height: 10),
              Text(
                'Upcoming Games:',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
              ),
              const SizedBox(height: 10),

              // ---------- Upcoming list (still scrolls but shrinkWrap) ----------
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
                    physics:
                        const NeverScrollableScrollPhysics(), // list inside scroll
                    shrinkWrap: true,
                    itemCount: games.length,
                    itemBuilder: (_, i) => _upcomingGameCard(games[i]),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Card for each game happening today ----------
  Widget _todayGameCard(Game game) {
    final dateFormatted = DateFormat('EEE, MMM d').format(game.date);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              _imageForFormat(game.format),
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Game",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                ),
                const SizedBox(height: 6),
                Text(
                  'You have RSVP’d for $dateFormatted • ${game.format}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 15),
                OutlinedButton.icon(
                  icon: Icon(Icons.play_circle,       
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF10138A),
                  ),
                  label: Text('View Game In Progress',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, // Optional: adds clarity
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF10138A),
                    ),
                  ),
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
                  icon: Icon(
                  Icons.leaderboard,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF10138A),
                  ),
                  label: Text(
                    'View Leaderboard',
                    style: TextStyle(
                      fontWeight: FontWeight.w600, // Optional: adds clarity
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF10138A),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF10138A),
                    ),
                    ),
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

  // ---------- Card when no game today ----------
  Widget _noGameTodayCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No Game Today',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
              ),
            const SizedBox(height: 6),
            Text(
              "No game scheduled for today or you haven't RSVP'd.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
              icon: Icon(
                Icons.leaderboard,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF10138A),
              ),
              label: Text(
                'View Leaderboard',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF10138A),
                  fontWeight: FontWeight.bold,
                ),
              ),
               style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF10138A),
                side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF10138A),
                ),
              ),
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

  // ---------- Upcoming game card ----------
  Widget _upcomingGameCard(Game game) {
    final bool hasRsvped = widget.user.hasRsvped(game);
    final String dateStr = DateFormat('EEE, MMM d, yyyy').format(game.date);

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
                        '${game.format} • $dateStr',
                        style: Theme.of(context).textTheme.bodyLarge,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        hasRsvped
                            ? Colors.redAccent
                            : Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white, // Ensure text is visible
                  ),
                  onPressed:
                      hasRsvped ? () => _unsign(game) : () => _rsvp(game),
                  child: Text(hasRsvped ? 'Cancel' : 'Register'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
