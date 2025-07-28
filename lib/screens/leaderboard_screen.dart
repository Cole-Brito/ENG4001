// lib/screens/leaderboard_screen.dart

/*
* UI Author : Bivin Job
*/

import 'package:flutter/material.dart';
import '../../models/game.dart'; // Source of leaderboard points

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, int>> scoreEntries =
        Game.leaderboard.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)); // DESC

    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: Colors.white,),
),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 4,
      ),
      body:
          scoreEntries.isEmpty
              ? Center(
                child: Text(
                  'No points recorded yet.',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Top Players by Points',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: scoreEntries.length,
                      itemBuilder: (_, index) {
                        final entry = scoreEntries[index];
                        final username = entry.key;
                        final points = entry.value;
                        final matches = Game.gamesPlayed[username] ?? 0;
                        final rank = index + 1;

                        IconData leadingIcon;
                        Color iconColor;
                        if (rank == 1) {
                          leadingIcon = Icons.emoji_events;
                          iconColor = Colors.amber.shade700;
                        } else if (rank == 2) {
                          leadingIcon = Icons.emoji_events;
                          iconColor = Colors.blueGrey.shade400;
                        } else if (rank == 3) {
                          leadingIcon = Icons.emoji_events;
                          iconColor = Colors.brown.shade400;
                        } else {
                          leadingIcon = Icons.format_list_numbered;
                          iconColor =
                              Theme.of(context).colorScheme.onSurfaceVariant;
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.secondaryContainer,
                                child: Text(
                                  '#$rank',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleSmall!.copyWith(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                username,
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '$points pts • $matches matches played',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              trailing: Icon(
                                leadingIcon,
                                color: iconColor,
                                size: rank <= 3 ? 30 : 24,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
