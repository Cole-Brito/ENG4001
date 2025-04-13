// lib/screens/game_play_screen.dart

import 'package:flutter/material.dart';
import '../models/game.dart';
import '../models/user.dart';

class GamePlayScreen extends StatelessWidget {
  final Game game;
  final User currentUser;

  const GamePlayScreen({
    super.key,
    required this.game,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTurn =
        game.queue.isNotEmpty &&
        game.queue.first.username == currentUser.username;

    return Scaffold(
      appBar: AppBar(title: const Text('Game In Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🗓️  Date: ${game.date.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '🎮 Format: ${game.format}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '🏟️ Courts Available: ${game.courts}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '👥 Players in Queue: ${game.queue.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            const Text(
              'Queue:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: game.queue.length,
                itemBuilder: (context, index) {
                  final player = game.queue[index];
                  final isCurrent = index == 0;

                  return ListTile(
                    leading: Text('#${index + 1}'),
                    title: Text(player.username),
                    trailing:
                        isCurrent
                            ? const Text(
                              'Your Turn',
                              style: TextStyle(color: Colors.green),
                            )
                            : null,
                  );
                },
              ),
            ),
            if (isTurn)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: navigate to player selection screen
                  },
                  child: const Text('Pick 3 Players'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
