// create_game_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Used for formatting dates
import '../../models/game.dart';
import '../../data/mock_game_store.dart'; // Mock data store for demo

/*
TODO: we need to implement a restful API to interface with our DB
at some point, this is fine for our demo (probably)

-Cole
*/

/*
Most of this class will become automated later down the line when we can have 
members sign up and RSVP for games remotely 

UI Improved by Bivin Job
*/

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  String _selectedFormat = 'Badminton'; // Default game format
  final _courtsController = TextEditingController();
  final _playersController = TextEditingController();
  DateTime? _selectedDate;
  String _message = '';

  // Supported game formats for dropdown
  final List<String> _gameFormats = ['Badminton', 'Tennis', 'Table Tennis'];

  // Rules for each game format (minimum required resources)
  final Map<String, Map<String, int>> formatRules = {
    'Badminton': {'courts': 2, 'players': 12},
    'Tennis': {'courts': 1, 'players': 4},
    'Table Tennis': {'courts': 1, 'players': 2},
  };

  // Date picker for selecting a game day
  // TODO: Also allow selecting a time of day in the future
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

  // Game creation logic based on selected format and input validation
  void _createGame() {
    final courts = int.tryParse(_courtsController.text) ?? 0;
    final players = int.tryParse(_playersController.text) ?? 0;

    if (_selectedDate == null) {
      setState(() => _message = '⚠️ Please select a date for the game.');
      return;
    }

    // Get required resources for selected format
    final requiredCourts = formatRules[_selectedFormat]!['courts']!;
    final requiredPlayers = formatRules[_selectedFormat]!['players']!;

    // Validate input against required resources
    if (courts >= requiredCourts && players >= requiredPlayers) {
      final newGame = Game(
        format: _selectedFormat,
        courts: courts,
        players: players,
        date: _selectedDate!,
      );

      // Add new game to the mock store
      MockGameStore.addGame(newGame);

      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      setState(() {
        _message =
            '✅ $_selectedFormat game created for $formattedDate\nCourts: $courts | Players: $players';
        _courtsController.clear();
        _playersController.clear();
        _selectedDate = null;
      });
    } else {
      setState(() {
        _message =
            '⚠️ Not enough resources for $_selectedFormat.\nMinimum: $requiredCourts courts, $requiredPlayers players.';
      });
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
        title: Text(
          'Create Game',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: Colors.white,),
        ),
        backgroundColor: Color(0xFF10138A),
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
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.sports_esports),
                      labelText: 'Game Format',
                      labelStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                      border: OutlineInputBorder(),
                    ),
                    items:
                        _gameFormats
                        .map(
                          (format) => DropdownMenuItem(
                            value: format,
                            child: Text(
                              format,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        )
                        .toList(),
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
                      labelStyle: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
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
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.grid_view),
                      labelText: 'Courts Available',
                      labelStyle: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Players scheduled ──
                  TextField(
                    controller: _playersController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.people),
                      labelText: 'Players Scheduled',
                      labelStyle: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ── Create button ──
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.check_circle_outline,
                      color: Colors.white,),
                      label: const Text('Create Game'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            elevation: 5,
                             textStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
// This screen allows users to create a new game by selecting the format, date, number of courts, and players.
// It validates the input against predefined rules for each game format and provides feedback on success or failure