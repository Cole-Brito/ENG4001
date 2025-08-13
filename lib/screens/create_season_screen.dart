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
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/custom_button.dart';

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
  TimeOfDay? _selectedTime;
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

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Select Game Start Time',
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _clearForm() {
    setState(() {
      _courtsController.clear();
      _playersController.clear();
      _startDate = null;
      _endDate = null;
      _selectedTime = null;
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
    if (_selectedTime == null) {
      _showSnackBar('Please select a start time for the games.', true);
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
      final startTime = DateTime(
        date.year,
        date.month,
        date.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      final newGame = Game(
        format: _selectedFormat,
        courts: courts,
        players: players,
        date: date,
        startTime: startTime,
      );
      MockGameStore.addGame(newGame);
    }

    _showSnackBar(
      '\u2705 Season created with ${gameDates.length} games from '
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

  @override
  Widget build(BuildContext context) {
    final formattedRange =
        (_startDate != null && _endDate != null)
            ? '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d, yyyy').format(_endDate!)}'
            : 'Select date range';
    final formattedTime =
        _selectedTime != null
            ? _selectedTime!.format(context)
            : 'Select a time';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '📆 Create Season',
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
          child: Form(
            key: _formKey,
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
                          Icons.event_repeat,
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
                              'Create Season',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Set up multiple games for the entire season',
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
                          'Season Details',
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
                              labelStyle: AppTextStyles.labelLarge.copyWith(
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
                                  Icons.sports_esports_outlined,
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
                                ['Badminton', 'Tennis', 'Table Tennis']
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
                            onChanged: (value) {
                              setState(() {
                                _selectedFormat = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Courts Field
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextFormField(
                            controller: _courtsController,
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
                                  Icons.sports_tennis,
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
                            keyboardType: TextInputType.number,
                            style: AppTextStyles.bodyMedium,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter number of courts';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Players Field
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextFormField(
                            controller: _playersController,
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
                                  Icons.group,
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
                            keyboardType: TextInputType.number,
                            style: AppTextStyles.bodyMedium,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter number of players';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Date Range Picker
                        InkWell(
                          onTap: _pickDateRange,
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
                                    Icons.date_range,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Season Range',
                                        style: AppTextStyles.labelMedium
                                            .copyWith(color: AppColors.primary),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formattedRange,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color:
                                                  _startDate != null &&
                                                          _endDate != null
                                                      ? AppColors.textLight
                                                      : AppColors
                                                          .textTertiaryLight,
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
                        // Time Picker
                        InkWell(
                          onTap: _pickTime,
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
                                    Icons.access_time,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Game Start Time',
                                        style: AppTextStyles.labelMedium
                                            .copyWith(color: AppColors.primary),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formattedTime,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color:
                                                  _selectedTime != null
                                                      ? AppColors.textLight
                                                      : AppColors
                                                          .textTertiaryLight,
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
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: 'Create Season',
                        icon: Icons.check,
                        onPressed: _createSeason,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        onPressed: _clearForm,
                        icon: Icon(Icons.clear, color: AppColors.primary),
                        tooltip: 'Clear Form',
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
