// lib/screens/game_play_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/game.dart';
import '../../models/user.dart';

class GamePlayScreen extends StatefulWidget {
  final Game game;
  final User currentUser;

  const GamePlayScreen({
    super.key,
    required this.game,
    required this.currentUser,
  });

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  final List<User> selectedPlayers = [];

  @override
  Widget build(BuildContext context) {
    final Game game = widget.game;
    final User currentUser = widget.currentUser;

    // Separate real users (from database) and mock users
    // Mock users will have fake email domains, database users will have real emails or no email
    final realUsers =
        game.queue.where((user) {
          // Real database users either:
          // 1. Have no email field set (null)
          // 2. Have empty email
          // 3. Have real email addresses (not fake domains)
          if (user.email == null || user.email!.isEmpty) {
            return true; // Database user with no email set
          }

          // Check if email contains fake domains (mock users)
          final email = user.email!.toLowerCase();
          return !email.contains('@fake.com') &&
              !email.contains('@mock.com') &&
              !email.contains('@test.com');
        }).toList();

    final mockUsers =
        game.queue.where((user) {
          // Mock users have fake email domains
          if (user.email == null || user.email!.isEmpty) {
            return false; // Not a mock user
          }

          final email = user.email!.toLowerCase();
          return email.contains('@fake.com') ||
              email.contains('@mock.com') ||
              email.contains('@test.com');
        }).toList();

    // Combine lists with real users first (database users prioritized)
    final orderedQueue = [...realUsers, ...mockUsers];

    // Debug: Print queue order (remove this in production)
    print('Queue Debug:');
    print(
      'Real users (${realUsers.length}): ${realUsers.map((u) => '${u.username}(${u.email ?? "no email"})').join(', ')}',
    );
    print(
      'Mock users (${mockUsers.length}): ${mockUsers.map((u) => '${u.username}(${u.email ?? "no email"})').join(', ')}',
    );
    print(
      'Final ordered queue: ${orderedQueue.map((u) => u.username).join(', ')}',
    );

    final bool isTurn =
        orderedQueue.isNotEmpty &&
        orderedQueue.first.username == currentUser.username;

    final otherPlayers = orderedQueue.where(
      (u) => u.username != currentUser.username,
    );

    // Assign available courts if any waiting group exists
    void assignCourtsIfAvailable(Game game) {
      for (int i = 1; i <= game.courts; i++) {
        if (!game.activeMatches.containsKey(i) &&
            game.waitingGroups.isNotEmpty) {
          final group = game.waitingGroups.removeAt(0);
          game.activeMatches[i] = Match(
            players: group,
            startTime: DateTime.now(),
          );
        }
      }
    }

    // Complete an active match and return players to the queue
    void completeMatch(Game game, int courtNumber) async {
      if (!game.activeMatches.containsKey(courtNumber)) return;

      final finishedGroup = game.activeMatches.remove(courtNumber)!.players;

      final winners = await showDialog<List<User>>(
        context: context,
        builder: (_) {
          final List<User> selected = [];

          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF10138A), Color(0xFF3B82F6)],
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.emoji_events, color: Colors.white, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'Who Won the Match?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        finishedGroup.map((user) {
                          final isSelected = selected.contains(user);
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient:
                                  isSelected
                                      ? LinearGradient(
                                        colors: [
                                          Colors.green.shade100,
                                          Colors.green.shade200,
                                        ],
                                      )
                                      : null,
                              color: isSelected ? null : Colors.grey.shade50,
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.green
                                        : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: CheckboxListTile(
                              title: Text(
                                user.username,
                                style: TextStyle(
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color:
                                      isSelected
                                          ? Colors.green.shade800
                                          : Colors.black87,
                                ),
                              ),
                              value: isSelected,
                              onChanged: (checked) {
                                setDialogState(() {
                                  if (checked == true && selected.length < 2) {
                                    selected.add(user);
                                  } else {
                                    selected.remove(user);
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              secondary: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                                color: isSelected ? Colors.green : Colors.grey,
                              ),
                              activeColor: Colors.green,
                            ),
                          );
                        }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, <User>[]),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, selected),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Confirm Winners',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );

      if (winners != null && winners.isNotEmpty) {
        setState(() {
          // Give 10 points to each winner
          for (final user in winners) {
            user.gamesPlayed += 10;

            // Update the Game's leaderboard map
            Game.leaderboard[user.username] =
                (Game.leaderboard[user.username] ?? 0) + 10;

            Game.gamesPlayed[user.username] =
                (Game.gamesPlayed[user.username] ?? 0) + 1;
          }

          // Return players to queue
          game.queue.addAll(finishedGroup);

          // Try to assign next waiting group
          assignCourtsIfAvailable(game);
        });

        // Update Firebase database for real users (not mock users)
        for (final winner in winners) {
          // Only update database for real users (not mock users)
          if (winner.email == null ||
              winner.email!.isEmpty ||
              (!winner.email!.contains('@fake.com') &&
                  !winner.email!.contains('@mock.com') &&
                  !winner.email!.contains('@test.com'))) {
            try {
              // Find user document by username
              final userQuery =
                  await FirebaseFirestore.instance
                      .collection('users')
                      .where('username', isEqualTo: winner.username)
                      .limit(1)
                      .get();

              if (userQuery.docs.isNotEmpty) {
                final userDoc = userQuery.docs.first;
                final currentScore = userDoc.data()['score'] ?? 0;
                final currentGames = userDoc.data()['games'] ?? 0;

                // Update score and games count in Firestore
                await userDoc.reference.update({
                  'score': currentScore + 10,
                  'games': currentGames + 1,
                  'lastUpdated': FieldValue.serverTimestamp(),
                });
              }
            } catch (e) {
              print('Error updating user score in Firebase: $e');
              // Continue without breaking the flow
            }
          }
        }

        // Optional: feedback message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '🏆 ${winners.map((u) => u.username).join(', ')} awarded 10 points!',
            ),
            backgroundColor: Colors.green.shade600,
          ),
        );
      }
    }

    // Form a group of 4 (current user + 3 others) and add to waiting
    void formMatchGroup(Game game, List<User> selectedPlayers) {
      // Use the current user (who is at the top of the ordered queue)
      final currentPlayerInQueue = orderedQueue.first;

      // Build group of 4: current user + 3 selected players
      final group = [currentPlayerInQueue, ...selectedPlayers];

      // Remove all group members from the original game queue
      for (final player in group) {
        game.queue.removeWhere((u) => u.username == player.username);
      }

      // Add to waiting room
      if (game.waitingGroups.length < 2) {
        game.waitingGroups.add(group);
      } else {
        // TODO - Show a message here
      }

      // Try to move to court if one is free
      assignCourtsIfAvailable(game);
    }

    //------------- UI CODE BELOW ---------------------

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Game In Progress',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF10138A),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10138A), Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Game Meta Info Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF10138A),
                          Color(0xFF1E3A8A),
                          Color(0xFF3B82F6),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Game Information',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _iconRow(
                            Icons.date_range,
                            'Date:',
                            '${game.date.toLocal().toString().split(' ')[0]}',
                            isWhiteText: true,
                          ),
                          _iconRow(
                            Icons.videogame_asset,
                            'Format:',
                            game.format,
                            isWhiteText: true,
                          ),
                          _iconRow(
                            Icons.sports_tennis,
                            'Courts Available:',
                            game.courts.toString(),
                            isWhiteText: true,
                          ),
                          _iconRow(
                            Icons.group,
                            'Players in Queue:',
                            orderedQueue.length.toString(),
                            isWhiteText: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Status Indicator
                if (game.waitingGroups.length >= 2)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade100,
                          Colors.orange.shade200,
                        ],
                      ),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Waiting rooms are full. Please wait for a court to become available.',
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                //Queue
                _sectionHeader(Icons.format_list_numbered, 'Player Queue'),
                const SizedBox(height: 8),

                // Real users vs Mock users info
                if (realUsers.isNotEmpty && mockUsers.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Real users (${realUsers.length}) are prioritized over test users (${mockUsers.length})',
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children:
                        orderedQueue.asMap().entries.map((entry) {
                          final index = entry.key;
                          final player = entry.value;
                          final isCurrent = index == 0;
                          final isMockUser =
                              player.email != null &&
                              (player.email!.contains('@fake.com') ||
                                  player.email!.contains('@mock.com') ||
                                  player.email!.contains('@test.com'));

                          return Container(
                            margin: EdgeInsets.only(top: index == 0 ? 0 : 1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                index == 0 ? 16 : 0,
                              ),
                              gradient:
                                  isCurrent
                                      ? const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF10138A),
                                          Color(0xFF1E3A8A),
                                          Color(0xFF3B82F6),
                                        ],
                                      )
                                      : null,
                              color:
                                  isCurrent
                                      ? null
                                      : (isMockUser
                                          ? Colors.grey.shade50
                                          : Colors.white),
                              border:
                                  isMockUser
                                      ? Border.all(
                                        color: Colors.orange.shade300,
                                        width: 1,
                                      )
                                      : null,
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient:
                                      isCurrent
                                          ? const LinearGradient(
                                            colors: [
                                              Colors.green,
                                              Colors.lightGreen,
                                            ],
                                          )
                                          : isMockUser
                                          ? LinearGradient(
                                            colors: [
                                              Colors.orange.shade300,
                                              Colors.orange.shade400,
                                            ],
                                          )
                                          : LinearGradient(
                                            colors: [
                                              Colors.blue.shade300,
                                              Colors.blue.shade400,
                                            ],
                                          ),
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      player.username,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge!.copyWith(
                                        color:
                                            isCurrent
                                                ? Colors.white
                                                : Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                        fontWeight:
                                            isCurrent
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  if (isMockUser && !isCurrent)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.orange.shade300,
                                        ),
                                      ),
                                      child: Text(
                                        'Test User',
                                        style: TextStyle(
                                          color: Colors.orange.shade700,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  if (!isMockUser && !isCurrent)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Real User',
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              trailing:
                                  isCurrent
                                      ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'Your Turn',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : isMockUser
                                      ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            game.queue.remove(player);
                                          });
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${player.username} removed from queue',
                                              ),
                                              backgroundColor:
                                                  Colors.orange.shade600,
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.red,
                                        ),
                                        tooltip: 'Remove test user',
                                      )
                                      : null,
                            ),
                          );
                        }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                //Wait rooms
                _sectionHeader(Icons.access_time, 'Waiting Rooms'),
                const SizedBox(height: 16),
                ...game.waitingGroups.asMap().entries.map((entry) {
                  final groupIndex = entry.key + 1;
                  final group = entry.value;
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.orange.shade100,
                            Colors.orange.shade200,
                          ],
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.orange, Colors.deepOrange],
                            ),
                          ),
                          child: const Icon(Icons.groups, color: Colors.white),
                        ),
                        title: Text(
                          'Room $groupIndex',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          group.map((u) => u.username).join(', '),
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Court views
                _sectionHeader(Icons.sports_handball_sharp, 'Active Matches'),
                ...game.activeMatches.entries.map((entry) {
                  final courtNum = entry.key;
                  final match = entry.value;
                  final duration = DateTime.now().difference(match.startTime);
                  final durationStr =
                      "${duration.inMinutes} min${duration.inMinutes != 1 ? 's' : ''} ago";

                  return Card(
                    elevation: 6,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.green.shade50,
                            Colors.green.shade100,
                            Colors.green.shade200,
                          ],
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF10138A),
                                const Color(0xFF3B82F6),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.sports_tennis,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          'Court $courtNum',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              match.players.map((u) => u.username).join(', '),
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Started: $durationStr',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton.icon(
                          onPressed: () {
                            setState(() => completeMatch(game, courtNum));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            elevation: 3,
                          ),
                          icon: const Icon(Icons.check_circle, size: 18),
                          label: const Text(
                            'Complete',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                // If the current member is at the top of the queue
                if (isTurn) ...[
                  const SizedBox(height: 30),
                  _sectionHeader(Icons.group_add, 'Form Your Group'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Select 3 players to form your group:',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              otherPlayers.map((player) {
                                final isSelected = selectedPlayers.contains(
                                  player,
                                );
                                return FilterChip(
                                  label: Text(
                                    player.username,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                  selected: isSelected,
                                  selectedColor: const Color(0xFF10138A),
                                  checkmarkColor: Colors.white,
                                  backgroundColor: Colors.grey.shade200,
                                  elevation: isSelected ? 4 : 2,
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected &&
                                          selectedPlayers.length < 3) {
                                        selectedPlayers.add(player);
                                      } else {
                                        selectedPlayers.remove(player);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:
          isTurn && game.waitingGroups.length < 2
              ? FloatingActionButton.extended(
                onPressed:
                    selectedPlayers.length == 3
                        ? () {
                          setState(() {
                            formMatchGroup(game, selectedPlayers);
                            selectedPlayers.clear();
                          });
                        }
                        : null,
                backgroundColor:
                    selectedPlayers.length == 3
                        ? const Color(0xFF10138A)
                        : Colors.grey.shade400,
                foregroundColor: Colors.white,
                label: Text(
                  selectedPlayers.length == 3
                      ? 'Form Group (${selectedPlayers.length}/3)'
                      : 'Select Players (${selectedPlayers.length}/3)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                icon: Icon(
                  selectedPlayers.length == 3
                      ? Icons.check_circle
                      : Icons.group_add,
                ),
                elevation: selectedPlayers.length == 3 ? 8 : 4,
              )
              : null,
    );
  }

  // ---------- Helper widgets ----------

  Widget _iconRow(
    IconData icon,
    String label,
    String value, {
    bool isWhiteText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: isWhiteText ? Colors.white70 : Colors.indigo),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  isWhiteText
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color:
                    isWhiteText
                        ? Colors.white70
                        : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFF10138A).withOpacity(0.1),
            const Color(0xFF3B82F6).withOpacity(0.1),
          ],
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF10138A), size: 24),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: const Color(0xFF10138A),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
