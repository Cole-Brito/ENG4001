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
//import '../models/game.dart';

class MemberDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final games = MockGameStore.games;

    return Scaffold(
      appBar: AppBar(title: Text('Member Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            games.isEmpty
                ? Center(child: Text('No scheduled games available.'))
                : ListView.builder(
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];
                    final dateFormatted = DateFormat(
                      'EEE, MMM d, yyyy', //
                    ).format(game.date);
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(Icons.sports),
                        title: Text('${game.format} Game'),
                        subtitle: Text(
                          'Date: $dateFormatted\n'
                          'Courts: ${game.courts} | Players: ${game.players}',
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
