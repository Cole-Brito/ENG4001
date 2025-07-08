// lib/scheduled_games_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/mock_game_store.dart';
import '../../models/game.dart';

class ScheduledGamesScreen extends StatelessWidget {
  const ScheduledGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Game> games = MockGameStore.games;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Games'),
        backgroundColor: Colors.indigo.shade600,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.indigo.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Guest!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ── Game list or fallback ──
            Expanded(
              child:
                  games.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.sports_esports_outlined,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No games scheduled yet.',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: games.length,
                        itemBuilder: (context, index) {
                          final game = games[index];
                          final dateFormatted = DateFormat(
                            'EEE, MMM d, yyyy',
                          ).format(game.date);

                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: const Icon(
                                Icons.event_available,
                                color: Colors.indigo,
                                size: 32,
                              ),
                              title: Text(
                                '${game.format} Game',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '📅 $dateFormatted\n'
                                  '🎾 Courts: ${game.courts}   👥 Players: ${game.players}',
                                  style: const TextStyle(height: 1.4),
                                ),
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
