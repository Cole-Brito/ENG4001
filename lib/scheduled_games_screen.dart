// lib/scheduled_games_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/mock_game_store.dart';
import '../models/game.dart';

class ScheduledGamesScreen extends StatelessWidget {
  const ScheduledGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Game> games = MockGameStore.games;

    return Scaffold(
      appBar: AppBar(title: Text('Scheduled Games')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Guest!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child:
                  games.isEmpty
                      ? Center(child: Text('No games scheduled yet.'))
                      : ListView.builder(
                        itemCount: games.length,
                        itemBuilder: (context, index) {
                          final game = games[index];
                          final dateFormatted = DateFormat(
                            'EEE, MMM d, yyyy',
                          ).format(game.date);
                          return Card(
                            margin: EdgeInsets.all(12),
                            child: ListTile(
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
          ],
        ),
      ),
    );
  }
}
