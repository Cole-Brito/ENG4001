import 'package:flutter/material.dart';
import '../data/mock_users.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Filter members only and ensure 'gamesPlayed' is treated as an int
    final List<Map<String, dynamic>> memberUsers =
        mockUsers
            .where((Map<String, dynamic> user) => user['role'] == 'member')
            .toList();
    final colorScheme = Theme.of(context).colorScheme;

    // Sort members by gamesPlayed DESCENDING
    memberUsers.sort(
      (Map<String, dynamic> a, Map<String, dynamic> b) =>
          ((b['gamesPlayed'] as int?) ?? 0).compareTo(
            ((a['gamesPlayed'] as int?) ?? 0),
          ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaderboard',
          style: const TextStyle(fontFamily: 'Bebasneuecyrillic', fontSize: 28),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body:
          memberUsers.isEmpty
              ? Center(
                child: Text(
                  'No members found for the leaderboard.',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Top Players by Games Played',
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
                      itemCount: memberUsers.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Map<String, dynamic> user = memberUsers[index];
                        final String username = user['username'] as String;
                        final int gamesPlayed =
                            (user['gamesPlayed'] as int?) ?? 0;
                        final int rank = index + 1;

                        IconData leadingIcon;
                        Color iconColor;
                        if (rank == 1) {
                          leadingIcon = Icons.emoji_events; // Gold trophy
                          iconColor = Colors.amber.shade700;
                        } else if (rank == 2) {
                          leadingIcon = Icons.emoji_events; // Silver trophy
                          iconColor = Colors.blueGrey.shade400;
                        } else if (rank == 3) {
                          leadingIcon = Icons.emoji_events; // Bronze trophy
                          iconColor = Colors.brown.shade400;
                        } else {
                          leadingIcon =
                              Icons
                                  .format_list_numbered; // Number icon for others
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                '$gamesPlayed Games Played',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
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
