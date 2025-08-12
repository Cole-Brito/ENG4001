// create_game_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Used for formatting dates
import '../../models/game.dart';
import '../../data/mock_game_store.dart'; // Mock data store for demo
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/custom_button.dart';

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
          '🎮 Create Game',
          style: AppTextStyles.titleLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10138A), Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: AppColors.primary.withOpacity(0.3),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFF), Color(0xFFE8F4FD)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create New Game',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Schedule a new game session for players',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Game Details',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Game Format Dropdown
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedFormat,
                          decoration: InputDecoration(
                            labelText: 'Game Format',
                            labelStyle: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.primary,
                            ),
                            prefixIcon: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.sports_esports,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          items:
                              _gameFormats
                                  .map(
                                    (format) => DropdownMenuItem(
                                      value: format,
                                      child: Text(
                                        format,
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (value) =>
                                  setState(() => _selectedFormat = value!),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Date picker
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 16),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Scheduled Day',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formattedDate,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color:
                                            _selectedDate != null
                                                ? AppColors.textLight
                                                : AppColors.textTertiaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: AppColors.textTertiaryLight,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Courts Field
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _courtsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Courts Available',
                            labelStyle: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.primary,
                            ),
                            prefixIcon: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.grid_view,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Players Field
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _playersController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Players Scheduled',
                            labelStyle: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.primary,
                            ),
                            prefixIcon: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.people,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Create button
                      CustomButton(
                        label: 'Create Game',
                        icon: Icons.check_circle_outline,
                        onPressed: _createGame,
                      ),

                      // Feedback message
                      if (_message.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                _message.contains('✅')
                                    ? AppColors.success.withOpacity(0.1)
                                    : AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  _message.contains('✅')
                                      ? AppColors.success
                                      : AppColors.warning,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _message.contains('✅')
                                    ? Icons.check_circle
                                    : Icons.warning,
                                color:
                                    _message.contains('✅')
                                        ? AppColors.success
                                        : AppColors.warning,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _message,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color:
                                        _message.contains('✅')
                                            ? AppColors.success
                                            : AppColors.warning,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// This screen allows users to create a new game by selecting the format, date, number of courts, and players.
// It validates the input against predefined rules for each game format and provides feedback on success or failure