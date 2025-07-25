/*
*
* Author: Cole Brito
* UI Author : Bivin Job
* Admin dashboard
*
*/

// lib/screens/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'create_game_screen.dart';
import 'scheduled_games_screen.dart';
import 'login_screen.dart';
import 'leaderboard_screen.dart';
import 'create_season_screen.dart';
import 'edit_scheduled_game_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _logout(BuildContext context) {
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
    return Scaffold(
      appBar: AppBar(
       title: Text(
          'ADMIN DASHBOARD',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: Colors.white,),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF10138A), // ROS Blue
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
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 0,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1, // square cards
                children: <Widget>[
                  _AdminDashboardActionCard(
                    icon: Icons.event_note,
                    title: 'Create New Game',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder:
                              (BuildContext context) =>
                                  const CreateGameScreen(),
                        ),
                      );
                    },
                  ),
                  _AdminDashboardActionCard(
                    icon: Icons.calendar_month,
                    title: 'View Scheduled Games',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder:
                              (BuildContext context) =>
                                  const ScheduledGamesScreen(),
                        ),
                      );
                    },
                  ),
                  _AdminDashboardActionCard(
                    icon: Icons.edit_calendar,
                    title: 'Edit Scheduled Games',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder:
                              (BuildContext context) =>
                                  EditScheduledGameScreen(),
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
                              (BuildContext context) =>
                                  const LeaderboardScreen(),
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
