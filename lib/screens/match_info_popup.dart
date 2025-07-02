import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/user.dart';

/// Match Info Dialog for selecting winners
class MatchInfoDialog extends StatefulWidget {
  final List<User> playersInMatch;
  final Function(List<User> winners) onMatchCompleted;

  const MatchInfoDialog({
    super.key,
    required this.playersInMatch,
    required this.onMatchCompleted,
  });

  @override
  State<MatchInfoDialog> createState() => _MatchInfoDialogState();
}

class _MatchInfoDialogState extends State<MatchInfoDialog> {
  final List<User> _selectedWinners = <User>[];

  @override
  Widget build(BuildContext context) {
    // Determine if it's a 1v1 match (2 players) or a doubles match (4 players)
    final bool isDoubles = widget.playersInMatch.length == 4;

    return AlertDialog(
      title: const Text('Match Result'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Select the winning player(s):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...widget.playersInMatch.map<Widget>((User player) {
              return CheckboxListTile(
                title: Text(player.username),
                value: _selectedWinners.contains(player),
                onChanged: (bool? selected) {
                  setState(() {
                    if (selected ?? false) {
                      if (isDoubles && _selectedWinners.length < 2) {
                        _selectedWinners.add(player);
                      } else if (!isDoubles && _selectedWinners.isEmpty) {
                        _selectedWinners.add(player);
                      } else if (!isDoubles && _selectedWinners.isNotEmpty) {
                        // For singles, only one winner
                        _selectedWinners
                          ..clear()
                          ..add(player);
                      }
                    } else {
                      _selectedWinners.remove(player);
                    }
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 20),
            if (isDoubles && _selectedWinners.length != 2)
              Text(
                'Please select 2 winners for a doubles match.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              )
            else if (!isDoubles && _selectedWinners.length != 1)
              Text(
                'Please select 1 winner for a singles match.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Dismiss the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              (_selectedWinners.length == (isDoubles ? 2 : 1))
                  ? () {
                    widget.onMatchCompleted(_selectedWinners);
                    Navigator.pop(context); // Dismiss the dialog
                  }
                  : null,
          child: const Text('Confirm Results'),
        ),
      ],
    );
  }
}
