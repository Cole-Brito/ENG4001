import 'package:flutter/material.dart';
// import removed: flutter_local_notifications
import 'package:intl/intl.dart';
import 'dart:math';
import '../../data/mock_game_store.dart';
import 'register_screen.dart';
import '../../models/game.dart';
import '../services/app_notification_manager.dart';
// import removed: notification_service.dart
import '../services/guest_firestore_service.dart';
import 'login_screen.dart';
import 'user_profile_screen.dart';
import '../../models/user.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  String? _guestUsername;
  String? _guestEmail;
  bool _notificationsEnabled = true;
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

  void _showSettingsDialog(BuildContext context) {
    final TextEditingController usernameController = TextEditingController(
      text: _guestUsername,
    );
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Change Username',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  value: _notificationsEnabled,
                  onChanged: (val) {
                    setState(() => _notificationsEnabled = val);
                    Navigator.of(context).pop();
                    _showSettingsDialog(context);
                  },
                  title: const Text('Enable Notifications'),
                  secondary: const Icon(Icons.notifications_active),
                ),
                const SizedBox(height: 16),
                if (_notificationsEnabled)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.notifications),
                    label: const Text('Send Test Notification'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      await AppNotificationManager.sendTestNotification();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Test notification sent!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _guestUsername =
                        usernameController.text.trim().isNotEmpty
                            ? usernameController.text.trim()
                            : _guestUsername;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  final Map<String, bool> _requestStatus = {}; // gameId -> sent/cancelled

  @override
  void initState() {
    super.initState();
    _promptForUserInfo();
  }

  // Helper to generate a random guest username
  String _generateRandomGuestName() {
    final random = Random();
    final number = random.nextInt(9000) + 1000;
    return 'Guest$number';
  }

  void _promptForUserInfo() async {
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    final randomGuestName = _generateRandomGuestName();
    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(builder: (_) => const GuestLoginScreen()),
    );
    String? inputName;
    String? inputEmail;
    if (result != null) {
      inputName = result['username'];
      inputEmail = result['email'];
    }
    if (result != null && mounted) {
      setState(() {
        _guestUsername =
            inputName?.isNotEmpty == true ? inputName! : randomGuestName;
        _guestEmail = inputEmail ?? '';
      });
      await AppNotificationManager.sendWelcomeNotification(_guestUsername!);
      // Save guest to Firestore with 1-day expiry
      try {
        await GuestFirestoreService().saveGuest(
          username: _guestUsername!,
          email: _guestEmail ?? '',
        );
      } catch (e) {
        // Optionally handle error
      }
    } else if (mounted) {
      setState(() {
        _guestUsername = randomGuestName;
        _guestEmail = '';
      });
    }
  }

  // ...existing code...

  Future<void> _requestToJoinGame(BuildContext context, Game game) async {
    final dateFormatted = DateFormat('EEE, MMM d, yyyy').format(game.date);
    final timeFormatted = TimeOfDay.fromDateTime(
      game.startTime,
    ).format(context);
    final gameId = _getGameId(game);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Request to Join Game'),
            content: Text(
              'Would you like to request access to join the game?\n\n'
              '📅 $dateFormatted at $timeFormatted\n'
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
                  onPressed: () async {
                    Navigator.pop(context);
                    await GuestFirestoreService().sendJoinRequest(
                      username: _guestUsername!,
                      email: _guestEmail!,
                      gameId: gameId,
                    );
                    // Add to in-memory pendingRequests for admin dashboard
                    if (game.pendingRequests != null &&
                        !game.pendingRequests!.contains(
                          '$_guestUsername ($_guestEmail)',
                        )) {
                      game.pendingRequests!.add(
                        '$_guestUsername ($_guestEmail)',
                      );
                    }
                    setState(() {
                      _requestStatus[gameId] = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Request sent to admin as $_guestUsername ($_guestEmail)',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
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

  Future<void> _cancelRequest(Game game) async {
    final gameId = _getGameId(game);
    await GuestFirestoreService().cancelJoinRequest(
      email: _guestEmail!,
      gameId: gameId,
    );
    setState(() {
      _requestStatus[gameId] = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request cancelled.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getGameId(Game game) {
    // Use a unique identifier for the game (format+date+startTime)
    return '${game.format}_${game.date.toIso8601String()}_${game.startTime.toIso8601String()}';
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

  // ...existing code...

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
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  // Navigate to user profile screen with guest info
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => UserProfileScreen(
                            user: User(
                              username: _guestUsername ?? 'Guest',
                              isAdmin: false,
                              isGuest: true,
                              email: _guestEmail,
                              rsvps: const [],
                            ),
                          ),
                    ),
                  );
                  break;
                case 'settings':
                  _showSettingsDialog(context);
                  break;
                case 'notifications':
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Notifications'),
                          content: const Text('No new notifications.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                  );
                  break;
                case 'about':
                  showAboutDialog(
                    context: context,
                    applicationName: 'ROS Racket Sports',
                    applicationVersion: '1.51',
                    applicationLegalese: '© 2025 ROS',
                  );
                  break;
                case 'logout':
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  break;
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: Row(
                      children: const [
                        Icon(Icons.person, color: Colors.grey),
                        SizedBox(width: 10),
                        Text('Profile'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'settings',
                    child: Row(
                      children: const [
                        Icon(Icons.settings, color: Colors.grey),
                        SizedBox(width: 10),
                        Text('Settings'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'notifications',
                    child: Row(
                      children: const [
                        Icon(Icons.notifications, color: Colors.grey),
                        SizedBox(width: 10),
                        Text('Notifications'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'about',
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline, color: Colors.grey),
                        SizedBox(width: 10),
                        Text('About'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: const [
                        Icon(Icons.logout, color: Colors.redAccent),
                        SizedBox(width: 10),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFF8FAFF)),
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
                          final timeFormatted = TimeOfDay.fromDateTime(
                            game.startTime,
                          ).format(context);
                          final gameId = _getGameId(game);
                          return FutureBuilder<bool>(
                            future: GuestFirestoreService().hasSentRequest(
                              email: _guestEmail!,
                              gameId: gameId,
                            ),
                            builder: (context, snapshot) {
                              final sent = snapshot.data ?? false;
                              return InkWell(
                                onTap:
                                    sent
                                        ? null
                                        : () =>
                                            _requestToJoinGame(context, game),
                                child: Card(
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 4,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
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
                                                                  Color(
                                                                    0xFF10138A,
                                                                  ),
                                                                  Color(
                                                                    0xFF3B82F6,
                                                                  ),
                                                                ],
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          game.format
                                                              .toUpperCase(),
                                                          style:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    '$dateFormatted  |  $timeFormatted',
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF1E3A8A),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    '📅 $dateFormatted at $timeFormatted\n🏟️ Courts: ${game.courts}   👥 Players: ${game.players}',
                                                    style: const TextStyle(
                                                      height: 1.4,
                                                      fontSize: 15,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  sent
                                                      ? Row(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 6,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  const Color.fromRGBO(
                                                                    76,
                                                                    175,
                                                                    80,
                                                                    0.15,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    20,
                                                                  ),
                                                            ),
                                                            child: const Text(
                                                              'Request Sent',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .green,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () =>
                                                                    _cancelRequest(
                                                                      game,
                                                                    ),
                                                            child: const Text(
                                                              'Cancel Request',
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                      : Container(
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
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                        child: const Text(
                                                          'Tap to Request Join',
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF10138A,
                                                            ),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
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

class GuestLoginScreen extends StatefulWidget {
  const GuestLoginScreen({super.key});

  @override
  State<GuestLoginScreen> createState() => _GuestLoginScreenState();
}

class _GuestLoginScreenState extends State<GuestLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late String _randomGuestName;

  @override
  void initState() {
    super.initState();
    _randomGuestName = _generateRandomGuestName();
  }

  String _generateRandomGuestName() {
    final random = Random();
    final number = random.nextInt(9000) + 1000;
    return 'Guest$number';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text('Guest Login', style: TextStyle(color: Colors.white)),
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFF), Color(0xFFE8F4FD)],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Guest Username',
                      hintText: _randomGuestName,
                      prefixIcon: const Icon(Icons.person),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Suggest random',
                        onPressed: () {
                          setState(() {
                            _randomGuestName = _generateRandomGuestName();
                            _nameController.text = _randomGuestName;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'e.g. guest@example.com',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop({
                          'username':
                              _nameController.text.trim().isNotEmpty
                                  ? _nameController.text.trim()
                                  : _randomGuestName,
                          'email': _emailController.text.trim(),
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: const Color(0xFF10138A),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
