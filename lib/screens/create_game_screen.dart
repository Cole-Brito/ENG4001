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
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _createGame() {
    int courts = int.tryParse(_courtsController.text) ?? 0;
    int players = int.tryParse(_playersController.text) ?? 0;

    if (_selectedDate == null) {
      setState(() {
        _message = 'WARNING: Please select a date for the game.';
      });
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
              'Game created for $formattedDate.\nCourts: $courts, Players: $players';
        });

        _courtsController.clear();
        _playersController.clear();
        _selectedDate = null;
      } else {
        setState(() {
          _message =
              'WARNING: Not enough resources for Badminton.\nMinimum: 2 courts, 12 players.';
        });
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
      appBar: AppBar(title: Text('Create Game')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _selectedFormat,
              onChanged: (value) {
                setState(() {
                  _selectedFormat = value!;
                });
              },
              items:
                  ['Badminton'].map((format) {
                    return DropdownMenuItem(value: format, child: Text(format));
                  }).toList(),
            ),
            // Date selection box
            SizedBox(height: 12),
            Text('Scheduled Day:'),
            TextButton.icon(
              icon: Icon(Icons.calendar_today),
              label: Text(formattedDate),
              onPressed: _pickDate,
            ),
            // Court Avaliblity box
            TextField(
              controller: _courtsController,
              decoration: InputDecoration(labelText: 'Courts Available'),
              keyboardType: TextInputType.number,
            ),
            // Player attendance box
            TextField(
              controller: _playersController,
              decoration: InputDecoration(labelText: 'Players Scheduled'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _createGame, child: Text('Create Game')),
            SizedBox(height: 16),
            Text(
              _message,
              style: TextStyle(fontSize: 16, color: Colors.indigo),
            ),
          ],
        ),
      ),
    );
  }
}
