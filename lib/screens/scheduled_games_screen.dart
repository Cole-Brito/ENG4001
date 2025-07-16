// Scheduled Games – now with banner images per game format
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/mock_game_store.dart';
import '../../models/game.dart';

class ScheduledGamesScreen extends StatelessWidget {
  const ScheduledGamesScreen({super.key});

  /// Returns the correct banner image path for a given game format.
  /// Update this map if you add more formats later.
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
            // ── Greeting ──
            const Text(
              'Welcome, Guest!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
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

                          // ── Card with top image + bottom details ──
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                // ── Top half: banner image ──
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.asset(
                                    _imageForFormat(game.format),
                                    width: double.infinity,
                                    height: 140, // ~half of card height
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // ── Bottom half: game info ──
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
                                              '${game.format} Game',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '📅 $dateFormatted\n'
                                              '🏟️ Courts: ${game.courts}   👥 Players: ${game.players}',
                                              style: const TextStyle(
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
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
