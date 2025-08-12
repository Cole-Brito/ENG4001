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
        content: Text(
          '✅ Signed up for ${game.format} • $dateStr',
          style: TextStyle(color: Colors.white),
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
                child: Text(
                  'No',
                  style: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.dark
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
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF10138A),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10138A), Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications),
              color: Colors.white,
              tooltip: 'Notifications',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.notifications, color: Colors.white),
                        SizedBox(width: 8),
                        Text('No new notifications'),
                      ],
                    ),
                    backgroundColor: const Color(0xFF10138A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.white),
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: const Row(
                          children: [
                            Icon(Icons.person, color: Color(0xFF10138A)),
                            SizedBox(width: 10),
                            Text(
                              'Profile',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'notifications',
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: const Row(
                          children: [
                            Icon(Icons.notifications, color: Color(0xFF10138A)),
                            SizedBox(width: 10),
                            Text(
                              'Notifications',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'settings',
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: const Row(
                          children: [
                            Icon(Icons.settings, color: Color(0xFF10138A)),
                            SizedBox(width: 10),
                            Text(
                              'Settings',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: const Row(
                          children: [
                            Icon(Icons.logout, color: Colors.redAccent),
                            SizedBox(width: 10),
                            Text(
                              'Logout',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
            ),
          ),
        ],
      ),

      // -------- full-page scroll --------------
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- greeting ----------
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF10138A),
                        Color(0xFF1E3A8A),
                        Color(0xFF3B82F6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back!',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium!.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              username,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ---------- Today’s games (0-n cards) ----------
                if (todayGames.isNotEmpty)
                  ...todayGames.map(_todayGameCard) // NEW: show all
                else
                  _noGameTodayCard(),

                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        const Color(0xFF10138A).withOpacity(0.1),
                        const Color(0xFF3B82F6).withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.upcoming,
                        color: Color(0xFF10138A),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Upcoming Games',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(
                          color: const Color(0xFF10138A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: games.length,
                      itemBuilder: (_, i) => _upcomingGameCard(games[i]),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Card for each game happening today ----------
  Widget _todayGameCard(Game game) {
    final dateFormatted = DateFormat('EEE, MMM d').format(game.date);
    return Card(
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade50, Colors.green.shade100],
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    _imageForFormat(game.format),
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'RSVP\'d',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                    icon: Icon(
                      Icons.play_circle,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color(0xFF10138A),
                    ),
                    label: Text(
                      'View Game In Progress',
                      style: TextStyle(
                        fontWeight: FontWeight.w600, // Optional: adds clarity
                        color:
                            Theme.of(context).brightness == Brightness.dark
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
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color(0xFF10138A),
                    ),
                    label: Text(
                      'View Leaderboard',
                      style: TextStyle(
                        fontWeight: FontWeight.w600, // Optional: adds clarity
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xFF10138A),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color:
                            Theme.of(context).brightness == Brightness.dark
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
      ),
    );
  }

  // ---------- Card when no game today ----------
  Widget _noGameTodayCard() {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade50, Colors.grey.shade100],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                    child: Icon(
                      Icons.event_busy,
                      color: Colors.grey.shade600,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'No Game Today',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "No game scheduled for today or you haven't RSVP'd.",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 15),
              OutlinedButton.icon(
                icon: Icon(
                  Icons.leaderboard,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF10138A),
                ),
                label: Text(
                  'View Leaderboard',
                  style: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF10138A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF10138A),
                  side: BorderSide(
                    color:
                        Theme.of(context).brightness == Brightness.dark
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
      ),
    );
  }

  // ---------- Upcoming game card ----------
  Widget _upcomingGameCard(Game game) {
    final bool hasRsvped = widget.user.hasRsvped(game);
    final String dateStr = DateFormat('EEE, MMM d, yyyy').format(game.date);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                hasRsvped
                    ? [Colors.blue.shade50, Colors.blue.shade100]
                    : [Colors.grey.shade50, Colors.grey.shade100],
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    _imageForFormat(game.format),
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
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
      ),
    );
  }
}
