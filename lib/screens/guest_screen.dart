import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/mock_game_store.dart';
import 'register_screen.dart';
import '../../models/game.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  String? _guestUsername;

  @override
  void initState() {
    super.initState();
    _promptForUsername();
  }

  void _promptForUsername() async {
    String? inputName;

    await Future.delayed(Duration.zero);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Enter a Guest Name'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Guest Username',
              hintText: 'e.g. Guest123',
            ),
            onChanged: (value) => inputName = value,
          ),
          actions: [
            TextButton(
              child: const Text('Random'),
              onPressed: () {
                inputName =
                    'Guest${DateTime.now().millisecondsSinceEpoch % 1000}';
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: const Text('Continue'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        );
      },
    );

    setState(() {
      _guestUsername =
          (inputName?.trim().isEmpty ?? true)
              ? 'Guest${DateTime.now().millisecondsSinceEpoch % 1000}'
              : inputName!;
    });
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Notifications'),
            content: const Text('You have no notifications at this time.'),
            actions: [
              TextButton(
                child: const Text('Okay'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  void _showAdDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Become a Member!'),
            content: const Text(
              'Enjoy full access to games, RSVP features, leaderboard tracking, and more by registering as a member.',
            ),
            actions: [
              TextButton(
                child: const Text('Close'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('Register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
              ),
            ],
          ),
    );
  }

  void _requestToJoinGame(BuildContext context, Game game) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Request to Join Game'),
            content: Text(
              'Would you like to request access to join the game?\n\n'
              '📅 ${DateFormat('EEE, MMM d, yyyy').format(game.date)}\n'
              '🏟️ Courts: ${game.courts}\n'
              '👥 Players: ${game.players}\n\n'
              'Admin approval required.',
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text('Send Request'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Request sent to admin as $_guestUsername'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  game.pendingRequests ??= [];
                  game.pendingRequests!.add(_guestUsername!);
                  setState(() {});
                },
              ),
            ],
          ),
    );
  }

  String _imageForFormat(String format) {
    switch (format.toLowerCase()) {
      case 'tennis':
        return 'assets/images/Tennis Court.png';
      case 'table tennis':
        return 'assets/images/Table Tennis.png';
      case 'badminton':
      default:
        return 'assets/images/Badminton Court.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_guestUsername == null || _guestUsername!.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Game> games = MockGameStore.games;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $_guestUsername'),
        backgroundColor: const Color(0xFF10138A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotifications(context),
          ),
          TextButton(
            onPressed: () => _showAdDialog(context),
            child: const Text(
              'Register',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.indigo.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.indigo, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Become a full member to RSVP games, view leaderboards, and unlock more features!',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  games.isEmpty
                      ? const Center(child: Text('No games scheduled yet.'))
                      : ListView.builder(
                        itemCount: games.length,
                        itemBuilder: (context, index) {
                          final game = games[index];
                          final dateFormatted = DateFormat(
                            'EEE, MMM d, yyyy',
                          ).format(game.date);
                          return InkWell(
                            onTap: () => _requestToJoinGame(context, game),
                            child: Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.asset(
                                      _imageForFormat(game.format),
                                      width: double.infinity,
                                      height: 140,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${game.format} Game',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                '📅 $dateFormatted\n🏟️ Courts: ${game.courts}   👥 Players: ${game.players}',
                                                style: const TextStyle(
                                                  height: 1.4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
