import 'package:flutter/material.dart';
import 'data/mock_users.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Filter members only
    final memberUsers = mockUsers
        .where((user) => user['role'] == 'member')
        .toList();

    // Sort members by gamesPlayed DESCENDING
    memberUsers.sort((a, b) =>
      ((b['gamesPlayed'] ?? 0) as int).compareTo((a['gamesPlayed'] ?? 0) as int));

    return Scaffold(
      appBar: AppBar(title: Text('Leaderboard')),
      body: ListView.builder(
        itemCount: memberUsers.length,
        itemBuilder: (context, index) {
          final user = memberUsers[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: CircleAvatar(child: Text('#${index + 1}')),
              title: Text('${user['username']}', style: TextStyle(fontSize: 18)),
              subtitle: Text('${user['gamesPlayed'] ?? 0} Games Played'),
            ),
          );
        },
      ),
    );
  }
}
