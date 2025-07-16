// lib/screens/game_play_screen.dart

import 'package:flutter/material.dart';
import '../../models/game.dart';
import '../../models/user.dart';

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

    // Assign available courts if any waiting group exists
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

    // Complete an active match and return players to the queue
    void completeMatch(Game game, int courtNumber) async {
      if (!game.activeMatches.containsKey(courtNumber)) return;

      final finishedGroup = game.activeMatches.remove(courtNumber)!.players;

      final winners = await showDialog<List<User>>(
        context: context,
        builder: (_) {
          final List<User> selected = [];

          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('🏆 Who Won the Match?'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        finishedGroup.map((user) {
                          final isSelected = selected.contains(user);
                          return Card(
                            elevation: isSelected ? 4 : 1,
                            color:
                                isSelected
                                    ? Colors.green.shade100
                                    : Colors.white,
                            child: CheckboxListTile(
                              title: Text(user.username),
                              value: isSelected,
                              onChanged: (checked) {
                                setDialogState(() {
                                  if (checked == true && selected.length < 2) {
                                    selected.add(user);
                                  } else {
                                    selected.remove(user);
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              secondary: const Icon(Icons.check_circle_outline),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, <User>[]),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, selected),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                    ),
                    child: const Text('Confirm Winners'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (winners != null && winners.isNotEmpty) {
        setState(() {
          // Give 10 points to each winner
          for (final user in winners) {
            user.gamesPlayed += 10;

            // Update the Game's leaderboard map
            Game.leaderboard[user.username] =
                (Game.leaderboard[user.username] ?? 0) + 10;

            Game.gamesPlayed[user.username] =
                (Game.gamesPlayed[user.username] ?? 0) + 1;
          }

          // Return players to queue
          game.queue.addAll(finishedGroup);

          // Try to assign next waiting group
          assignCourtsIfAvailable(game);
        });

        // Optional: feedback message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '🏆 ${winners.map((u) => u.username).join(', ')} awarded 10 points!',
            ),
            backgroundColor: Colors.green.shade600,
          ),
        );
      }
    }

    // Form a group of 4 (current user + 3 others) and add to waiting
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
      appBar: AppBar(
        title: const Text('Game In Progress'),
        backgroundColor: Colors.indigo.shade600,
        elevation: 0,
      ),
      body: Container(
        // Background gradient for modern look
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.indigo.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Game Meta Info Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _iconRow(
                      Icons.date_range,
                      'Date:',
                      '${game.date.toLocal().toString().split(' ')[0]}',
                    ),
                    _iconRow(Icons.videogame_asset, 'Format:', game.format),
                    _iconRow(
                      Icons.sports_tennis,
                      'Courts Available:',
                      game.courts.toString(),
                    ),
                    _iconRow(
                      Icons.group,
                      'Players in Queue:',
                      game.queue.length.toString(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            //Queue
            _sectionHeader(Icons.format_list_numbered, 'Queue'),
            const SizedBox(height: 6),
            ...game.queue.asMap().entries.map((entry) {
              final index = entry.key;
              final player = entry.value;
              final isCurrent = index == 0;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        isCurrent ? Colors.green : Colors.grey.shade300,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(player.username),
                  trailing:
                      isCurrent
                          ? const Icon(Icons.star, color: Colors.green)
                          : null,
                ),
              );
            }),

            const SizedBox(height: 24),

            //Wait rooms
            _sectionHeader(Icons.access_time, 'Waiting Rooms'),
            ...game.waitingGroups.asMap().entries.map((entry) {
              final groupIndex = entry.key + 1;
              final group = entry.value;
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.groups, color: Colors.indigo),
                  title: Text('Room $groupIndex'),
                  subtitle: Text(group.map((u) => u.username).join(', ')),
                ),
              );
            }),

            const SizedBox(height: 24),

            // Court views
            _sectionHeader(Icons.sports_handball_sharp, 'Active Matches'),
            ...game.activeMatches.entries.map((entry) {
              final courtNum = entry.key;
              final match = entry.value;
              final duration = DateTime.now().difference(match.startTime);
              final durationStr =
                  "${duration.inMinutes} min${duration.inMinutes != 1 ? 's' : ''} ago";

              return Card(
                color: Colors.indigo.shade100.withOpacity(0.2),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(
                    Icons.sports_tennis,
                    color: Colors.indigo,
                    size: 28,
                  ),
                  title: Text('Court $courtNum'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(match.players.map((u) => u.username).join(', ')),
                      Text('Started: $durationStr'),
                    ],
                  ),
                  trailing: ElevatedButton.icon(
                    onPressed: () {
                      setState(() => completeMatch(game, courtNum));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(fontSize: 14),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text('Complete'),
                  ),
                ),
              );
            }),

            // If the current member is at the top of the queue
            if (isTurn) ...[
              const SizedBox(height: 30),
              _sectionHeader(Icons.group_add, 'Form Your Group'),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children:
                    otherPlayers.map((player) {
                      final isSelected = selectedPlayers.contains(player);
                      return FilterChip(
                        label: Text(player.username),
                        selected: isSelected,
                        selectedColor: Colors.indigoAccent.shade100,
                        checkmarkColor: Colors.white,
                        backgroundColor: Colors.black,
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
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
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
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Confirm Group'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------- Helper widgets ----------

  Widget _iconRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo.shade700),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
