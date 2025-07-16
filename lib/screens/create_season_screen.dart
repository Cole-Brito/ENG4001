/*
*
* Author: Cole Brito
* UI Author : Bivin Job
* Create Season Screen
*
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/game.dart';
import '../data/mock_game_store.dart';

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
  final _formKey = GlobalKey<FormState>();

  void _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _clearForm() {
    setState(() {
      _courtsController.clear();
      _playersController.clear();
      _startDate = null;
      _endDate = null;
    });
  }

  void _createSeason() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final courts = int.tryParse(_courtsController.text) ?? 0;
    final players = int.tryParse(_playersController.text) ?? 0;

    if (_startDate == null || _endDate == null) {
      _showSnackBar('Please select a date range for the season.', true);
      return;
    }

    if (_startDate!.isAfter(_endDate!)) {
      _showSnackBar('Start date must be before end date.', true);
      return;
    }

    final gameDates = <DateTime>[];
    var currentDate = _startDate!;
    while (!currentDate.isAfter(_endDate!)) {
      gameDates.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 7)); // Weekly
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

    _showSnackBar(
      '✅ Season created with ${gameDates.length} games from '
      '${DateFormat.yMMMd().format(_startDate!)} to '
      '${DateFormat.yMMMd().format(_endDate!)}.',
      false,
    );

    _clearForm();
  }

  void _showSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade600,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ----------------- UI -----------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedRange =
        (_startDate != null && _endDate != null)
            ? '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d, yyyy').format(_endDate!)}'
            : 'Select date range';

    return Scaffold(
      appBar: AppBar(
        title: const Text('📆 Create Season'),
        elevation: 3,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedFormat,
                        decoration: const InputDecoration(
                          labelText: 'Game Format',
                          prefixIcon: Icon(Icons.sports_esports_outlined),
                          border: OutlineInputBorder(),
                        ),
                        items:
                            ['Badminton', 'Tennis', 'Table Tennis']
                                .map(
                                  (format) => DropdownMenuItem(
                                    value: format,
                                    child: Text(format),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFormat = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _courtsController,
                        decoration: const InputDecoration(
                          labelText: 'Courts Available',
                          prefixIcon: Icon(Icons.sports_tennis),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter number of courts';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _playersController,
                        decoration: const InputDecoration(
                          labelText: 'Players Scheduled',
                          prefixIcon: Icon(Icons.group),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter number of players';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.date_range),
                        title: const Text('Season Range'),
                        subtitle: Text(
                          formattedRange,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        onTap: _pickDateRange,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Create Season'),
                      onPressed: _createSeason,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: _clearForm,
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear Form',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
