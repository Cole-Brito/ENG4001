// lib/screens/game_play_screen.dart

import 'package:flutter/material.dart';
import '../models/game.dart';
import '../models/user.dart';

class GamePlayScreen extends StatefulWidget {
  final Game game;
  final User currentUser;

  const GamePlayScreen({
    super.key,
    required this.game,
    required this.currentUser,
  });

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  final List<User> selectedPlayers = [];

  @override
  Widget build(BuildContext context) {
    final Game game = widget.game;
    final User currentUser = widget.currentUser;
    final bool isTurn =
        game.queue.isNotEmpty &&
        game.queue.first.username == currentUser.username;

    final otherPlayers = game.queue.where(
      (u) => u.username != currentUser.username,
    );

    void assignCourtsIfAvailable(Game game) {
      for (int i = 1; i <= game.courts; i++) {
        if (!game.activeMatches.containsKey(i) &&
            game.waitingGroups.isNotEmpty) {
          final group = game.waitingGroups.removeAt(0);
          game.activeMatches[i] = Match(
            players: group,
            startTime: DateTime.now(),
          );
        }
      }
    }

    void completeMatch(Game game, int courtNumber) {
      if (game.activeMatches.containsKey(courtNumber)) {
        final finishedGroup = game.activeMatches.remove(courtNumber)!.players;
        game.queue.addAll(finishedGroup);
      }

      // Try to assign next waiting group
      assignCourtsIfAvailable(game);
    }

    void formMatchGroup(Game game, List<User> selectedPlayers) {
      final currentUser = game.queue.first;

      // Build group of 4
      final group = [currentUser, ...selectedPlayers];

      // Remove from queue
      game.queue.removeWhere((u) => group.contains(u));

      // Add to waiting room
      if (game.waitingGroups.length < 2) {
        game.waitingGroups.add(group);
      } else {
        // TODO - Show a message here
      }

      // Try to move to court if one is free
      assignCourtsIfAvailable(game);
    }

    //------------- UI CODE BELOW ---------------------

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
            //Queue
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
                              '🎯 Your Turn',
                              style: TextStyle(color: Colors.green),
                            )
                            : null,
                  );
                },
              ),
            ),
            //Wait rooms
            const SizedBox(height: 20),
            const Text(
              '🕓 Waiting Rooms:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...game.waitingGroups.asMap().entries.map((entry) {
              final groupIndex = entry.key + 1;
              final group = entry.value;
              return ListTile(
                leading: Text('Room $groupIndex'),
                title: Text(group.map((u) => u.username).join(', ')),
              );
            }),
            // Court views
            const SizedBox(height: 20),
            const Text(
              '🏸 Active Matches:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...game.activeMatches.entries.map((entry) {
              final courtNum = entry.key;
              final match = entry.value;
              final duration = DateTime.now().difference(match.startTime);
              final durationStr =
                  "${duration.inMinutes} min${duration.inMinutes != 1 ? 's' : ''} ago";

              return ListTile(
                leading: Text('Court $courtNum'),
                title: Text(match.players.map((u) => u.username).join(', ')),
                subtitle: Text('Started: $durationStr'),
                trailing: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      completeMatch(game, courtNum);
                    });
                  },
                  child: const Text('Complete Match'),
                ),
              );
            }),
            // If the current member is at the top of the queue
            if (isTurn) ...[
              const SizedBox(height: 20),
              const Text(
                'Pick 3 players to form a group:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children:
                    otherPlayers.map((player) {
                      final isSelected = selectedPlayers.contains(player);
                      return FilterChip(
                        label: Text(player.username),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected && selectedPlayers.length < 3) {
                              selectedPlayers.add(player);
                            } else {
                              selectedPlayers.remove(player);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  // Creates group and removes them from queue, adding them to a
                  // waiting room or assgins them to a court
                  onPressed:
                      selectedPlayers.length == 3
                          ? () {
                            setState(() {
                              formMatchGroup(game, selectedPlayers);
                              selectedPlayers.clear();
                            });
                          }
                          : null,
                  child: const Text('Confirm Group'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
