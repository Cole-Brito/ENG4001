import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/game.dart';
import '../data/mock_game_store.dart';

/**
 * TODO HERE:
 * - Make it so that it selects a specific day each week
 * - 
 * -
 */

class CreateSeasonScreen extends StatefulWidget {
  const CreateSeasonScreen({super.key});

  @override
  _CreateSeasonScreenState createState() => _CreateSeasonScreenState();
}

class _CreateSeasonScreenState extends State<CreateSeasonScreen> {
  String _selectedFormat = 'Badminton';
  final _courtsController = TextEditingController();
  final _playersController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _message = '';

  void _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _createSeason() {
    int courts = int.tryParse(_courtsController.text) ?? 0;
    int players = int.tryParse(_playersController.text) ?? 0;

    if (_startDate == null || _endDate == null) {
      setState(() {
        _message = 'WARNING: Please select a date range for the season.';
      });
      return;
    }

    if (_startDate!.isAfter(_endDate!)) {
      setState(() {
        _message = 'WARNING: Start date must be before end date.';
      });
      return;
    }

    List<DateTime> gameDates = [];
    DateTime currentDate = _startDate!;
    while (!currentDate.isAfter(_endDate!)) {
      gameDates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 7)); // Weekly
    }

    for (final date in gameDates) {
      final newGame = Game(
        format: _selectedFormat,
        courts: courts,
        players: players,
        date: date,
      );
      MockGameStore.addGame(newGame);
    }

    setState(() {
      _message =
          '✅ Season created with ${gameDates.length} games from ${DateFormat.yMMMd().format(_startDate!)} to ${DateFormat.yMMMd().format(_endDate!)}.';
      _courtsController.clear();
      _playersController.clear();
      _startDate = null;
      _endDate = null;
    });
  }

  // -------------- UI CODE BELOW ------------

  @override
  Widget build(BuildContext context) {
    final formattedRange =
        _startDate != null && _endDate != null
            ? '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d, yyyy').format(_endDate!)}'
            : 'Select date range';

    return Scaffold(
      appBar: AppBar(title: Text('Create Season')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _selectedFormat,
              onChanged: (value) => setState(() => _selectedFormat = value!),
              items:
                  ['Badminton']
                      .map(
                        (format) => DropdownMenuItem(
                          value: format,
                          child: Text(format),
                        ),
                      )
                      .toList(),
            ),
            SizedBox(height: 12),
            Text('Season Range:'),
            TextButton.icon(
              icon: Icon(Icons.date_range),
              label: Text(formattedRange),
              onPressed: _pickDateRange,
            ),
            TextField(
              controller: _courtsController,
              decoration: InputDecoration(labelText: 'Courts Available'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _playersController,
              decoration: InputDecoration(labelText: 'Players Scheduled'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createSeason,
              child: Text('Create Season'),
            ),
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
