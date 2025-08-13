// lib/screens/select_game_to_edit_screen.dart
import 'package:flutter/material.dart';
import '../../data/mock_game_store.dart';
import '../../models/game.dart';
import 'package:intl/intl.dart';

class EditScheduledGameScreen extends StatefulWidget {
  @override
  State<EditScheduledGameScreen> createState() =>
      _EditScheduledGameScreenState();
}

// Doesnt allow the admin to do an illegal action  (like a badminton game
// with less 12 players) and allow the change of game formats

class _EditScheduledGameScreenState extends State<EditScheduledGameScreen> {
  void _editGameDialog(Game game) {
    final formatController = TextEditingController(text: game.format);
    final courtsController = TextEditingController(
      text: game.courts.toString(),
    );
    final playersController = TextEditingController(
      text: game.players.toString(),
    );
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(game.startTime);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Game'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: formatController,
                      decoration: const InputDecoration(labelText: 'Format'),
                    ),
                    TextField(
                      controller: courtsController,
                      decoration: const InputDecoration(labelText: 'Courts'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: playersController,
                      decoration: const InputDecoration(labelText: 'Players'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.access_time),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Start Time: ${selectedTime.format(context)}',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            );
                            if (picked != null) {
                              setDialogState(() {
                                selectedTime = picked;
                              });
                            }
                          },
                          child: const Text('Edit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final updatedGame = game.copyWith(
                      format: formatController.text,
                      courts:
                          int.tryParse(courtsController.text) ?? game.courts,
                      players:
                          int.tryParse(playersController.text) ?? game.players,
                      startTime: DateTime(
                        game.startTime.year,
                        game.startTime.month,
                        game.startTime.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      ),
                    );
                    MockGameStore.updateGame(game, updatedGame);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final games = MockGameStore.games;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Scheduled Games',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF10138A), // ROS Blue
        elevation: 4,
      ),
      body:
          games.isEmpty
              ? const Center(child: Text('No games scheduled yet.'))
              : ListView.builder(
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];

                  //Date formatting
                  final dateFormatted = DateFormat('MMM d').format(game.date);
                  final timeFormatted = TimeOfDay.fromDateTime(
                    game.startTime,
                  ).format(context);

                  return Card(
                    margin: const EdgeInsets.all(12),
                    child: ListTile(
                      title: Row(
                        children: [
                          Text('${game.format} Game'),
                          const SizedBox(width: 12),
                          Text(
                            dateFormatted,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeFormatted,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        'Courts: ${game.courts} | Players: ${game.players}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editGameDialog(game),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
