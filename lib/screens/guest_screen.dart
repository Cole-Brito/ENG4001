import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/mock_game_store.dart';
import 'register_screen.dart';
import '../../models/game.dart';
import '../services/app_notification_manager.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  String? _guestUsername;
  String? _guestEmail;

  @override
  void initState() {
    super.initState();
    _promptForUserInfo();
  }

  void _promptForUserInfo() async {
    // Wait for the widget to be fully built
    await Future.delayed(Duration.zero);

    if (!mounted) return;

    String? inputName;
    String? inputEmail;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();
        final TextEditingController nameController = TextEditingController();
        final TextEditingController emailController = TextEditingController();

        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: const Text('Guest Information'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Guest Username',
                        hintText: 'e.g. Guest123',
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (value) => inputName = value,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'e.g. guest@example.com',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => inputEmail = value,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        // Basic email validation
                        final emailRegex = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        );
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton.icon(
                  icon: const Icon(Icons.shuffle, size: 16),
                  label: const Text('Random Username'),
                  onPressed: () {
                    final randomUsername =
                        'Guest${DateTime.now().millisecondsSinceEpoch % 1000}';
                    nameController.text = randomUsername;
                    inputName = randomUsername;
                    dialogSetState(() {}); // Update the dialog UI
                  },
                ),
                TextButton(
                  child: const Text('Continue'),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      inputName = nameController.text.trim();
                      inputEmail = emailController.text.trim();
                      Navigator.of(dialogContext).pop(true);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    // Only update state if we got valid results and widget is still mounted
    if (result == true && mounted) {
      setState(() {
        _guestUsername =
            inputName?.isNotEmpty == true
                ? inputName!
                : 'Guest${DateTime.now().millisecondsSinceEpoch % 1000}';
        _guestEmail = inputEmail ?? '';
      });

      // Debug logging
      print('Guest Username: $_guestUsername');
      print('Guest Email: $_guestEmail');

      // Send welcome notification after state is set
      if (_guestUsername != null && _guestUsername!.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            AppNotificationManager.sendWelcomeNotification(_guestUsername!);
          }
        });
      }
    } else if (mounted) {
      // If dialog was dismissed, set default values
      setState(() {
        _guestUsername = 'Guest${DateTime.now().millisecondsSinceEpoch % 1000}';
        _guestEmail = '';
      });
    }
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Notifications'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('You have no notifications at this time.'),
                const SizedBox(height: 16),
                const Text(
                  'Test Notifications:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.notification_add, size: 16),
                  label: const Text('Test Local Notification'),
                  onPressed: () async {
                    await AppNotificationManager.sendTestNotification();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Test notification sent!')),
                    );
                  },
                ),
              ],
            ),
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
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10138A), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person_add, color: Colors.white),
                  label: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                ),
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
              'Your request will be sent as:\n'
              '👤 $_guestUsername\n'
              '📧 $_guestEmail\n\n'
              'Admin approval required.',
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10138A), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Request sent to admin as $_guestUsername ($_guestEmail)',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    game.pendingRequests ??= [];
                    game.pendingRequests!.add('$_guestUsername ($_guestEmail)');
                    setState(() {});
                  },
                  child: const Text(
                    'Send Request',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
    // Show loading while gathering user info
    if (_guestUsername == null || _guestUsername!.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Show error if email is missing (since it's required)
    if (_guestEmail == null || _guestEmail!.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Email is required for guest access',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Please restart the app and provide a valid email.'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _promptForUserInfo(),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    final List<Game> games = MockGameStore.games;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $_guestUsername',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Text(
              _guestEmail!,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFF), Color(0xFFE8F4FD)],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF10138A),
                    Color(0xFF1E3A8A),
                    Color(0xFF3B82F6),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Become a full member to RSVP games, view leaderboards, and unlock more features!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
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
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.asset(
                                      _imageForFormat(game.format),
                                      width: double.infinity,
                                      height: 140,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          const LinearGradient(
                                                            colors: [
                                                              Color(0xFF10138A),
                                                              Color(0xFF3B82F6),
                                                            ],
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      game.format.toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                dateFormatted,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF1E3A8A),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                '📅 $dateFormatted\n🏟️ Courts: ${game.courts}   👥 Players: ${game.players}',
                                                style: const TextStyle(
                                                  height: 1.4,
                                                  fontSize: 15,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF10138A,
                                                  ).withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Text(
                                                  'Tap to Request Join',
                                                  style: TextStyle(
                                                    color: Color(0xFF10138A),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
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
