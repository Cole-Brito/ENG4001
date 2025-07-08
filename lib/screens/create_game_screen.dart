// create_game_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //This is how im doing the dates
import '../../models/game.dart';
import '../../data/mock_game_store.dart'; // This is the mock database

/*
TODO: we need to implement a restful api to interface with our DB
at some point, this is fine for our demo (probably)

-Cole
*/

/*
Most of this class will become automated later down the line when we can have 
members sign up and rsvp for games remotely 
*/

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  String _selectedFormat = 'Badminton'; // Defulat to badminton for now
  final _courtsController = TextEditingController();
  final _playersController = TextEditingController();
  DateTime? _selectedDate;
  String _message = '';

  // Date picker for selecting a game day
  // TODO: Also select a time of day !!
  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select Game Day',
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _createGame() {
    final courts = int.tryParse(_courtsController.text) ?? 0;
    final players = int.tryParse(_playersController.text) ?? 0;

    if (_selectedDate == null) {
      setState(() => _message = '⚠️  Please select a date for the game.');
      return;
    }

    // Rules for a formats avaliblity
    //TODO: Move this to a diffrent file and import it here when theres more
    //formats to take care of
    if (_selectedFormat == 'Badminton') {
      if (courts >= 2 && players >= 12) {
        final newGame = Game(
          format: _selectedFormat,
          courts: courts,
          players: players,
          date: _selectedDate!,
        );

        MockGameStore.addGame(newGame);

        final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
        setState(() {
          _message =
              '✅ Game created for $formattedDate\nCourts: $courts | Players: $players';
          _courtsController.clear();
          _playersController.clear();
          _selectedDate = null;
        });
      } else {
        setState(
          () =>
              _message =
                  '⚠️  Not enough resources for Badminton.\nMinimum: 2 courts, 12 players.',
        );
      }
    }
  }

  //--------------------- UI CODE BELOW ---------------------
  @override
  Widget build(BuildContext context) {
    final formattedDate =
        _selectedDate != null
            ? DateFormat('EEE, MMM d, yyyy').format(_selectedDate!)
            : 'Select a date';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Game'),
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
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Format dropdown ──
                  DropdownButtonFormField<String>(
                    value: _selectedFormat,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.sports),
                      labelText: 'Game Format',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Badminton',
                        child: Text('Badminton'),
                      ),
                    ],
                    onChanged:
                        (value) => setState(() => _selectedFormat = value!),
                  ),
                  const SizedBox(height: 20),

                  // ── Date picker ──
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_today),
                      labelText: 'Scheduled Day',
                      hintText: formattedDate,
                      border: const OutlineInputBorder(),
                    ),
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 20),

                  // ── Courts available ──
                  TextField(
                    controller: _courtsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.grid_view),
                      labelText: 'Courts Available',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Players scheduled ──
                  TextField(
                    controller: _playersController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.people),
                      labelText: 'Players Scheduled',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ── Create button ──
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Create Game'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: _createGame,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Feedback message ──
                  if (_message.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade100.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _message,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
