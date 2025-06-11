/*
*
* Author: Cole Brito
* Admin dashboard
*
*/

// lib/screens/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'create_game_screen.dart';
import 'scheduled_games_screen.dart';
import 'login_screen.dart';
import 'leaderboard_screen.dart'; 

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  //Logout function
  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context), //Logout button on the top bar
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Button for creating a game
            ElevatedButton(
              child: Text('Create Game'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateGameScreen()),
                );
              },
            ),
            //Button for viewing schduled games
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('View Scheduled Games'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScheduledGamesScreen(),
                  ),
                );
              },
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LeaderboardScreen()),
                );
              },
              child: Text('View Leaderboard'),
            ),
          ],
        ),
      ),
    );
  }
}
