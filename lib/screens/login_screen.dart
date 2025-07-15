/*
* Author: Cole Brito
* ENG4001_020
* Basic login screen and autherization of users logic
*/

import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/admin_dashboard.dart';
import 'package:flutter_application_2/screens/member_dashboard.dart';
import 'package:flutter_application_2/models/user.dart';
import 'package:flutter_application_2/screens/register_screen.dart';
import 'package:flutter_application_2/screens/scheduled_games_screen.dart';
import '../data/mock_users.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Text field editors
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Basic login logic and authorization logic
  void _login() {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    final Map<String, String> userMap = mockUsers.firstWhere(
      (Map<String, String> u) =>
          u['username'] == username && u['password'] == password,
      orElse: () => <String, String>{},
    );

    if (userMap.isNotEmpty) {
      final String? role = userMap['role'];

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const AdminDashboard(),
          ),
        );
      } else if (role == 'member') {
        // Converting map into a User object
        final User user = User(username: userMap['username']!, isAdmin: false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MemberDashboard(user: user),
          ),
        );
      } else {
        _showError('Invalid role');
      }
    } else {
      _showError('Invalid username or password');
    }
  }

  // Guest Login -- Can only see the scheduled games for now
  void _guestLogin() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const ScheduledGamesScreen(),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //--------------------- UI CODE BELOW ---------------------
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;

    return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.background,
      /*
      appBar: AppBar(
        title: Text(
          'ROS LOGIN',
           style: const TextStyle(
        fontFamily: 'Bebasneuecyrillic',
        fontSize: 28,
            ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF10138A), // ROS Blue
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      */
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isSmallScreen ? double.infinity : 450,
            ),
            child: Card(
              color: Theme.of(context).colorScheme.surface,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/ROS_Logo.png',
                      height: isSmallScreen ? 90 : 130,
                    ),
                    SizedBox(height: isSmallScreen ? 28 : 40),
                    Text(
                      'Welcome Back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      textAlign: TextAlign.center,
                     style: TextStyle(
                        fontFamily: 'GlacialIndifference',
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 32 : 48),
                    TextField(
                      controller: _usernameController,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      decoration: InputDecoration(
                        labelText: 'Username',
                         labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        hintText: 'Enter your username',
                         hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withOpacity(0.6),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                          color: Color(0xFF10138A), // ROS Blue
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest.withOpacity(0.2),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18.0,
                          horizontal: 16.0,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          ),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withOpacity(0.6),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFF10138A), // ROS Blue
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest.withOpacity(0.2),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18.0,
                          horizontal: 16.0,
                        ),
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _login(),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        backgroundColor: 
                            const Color(0xFF10138A),
                        foregroundColor: Colors.white,
                        elevation: 5,
                        textStyle: const TextStyle(
                          fontFamily: 'GlacialIndifference',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _guestLogin,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: BorderSide(
                        color: const Color(0xFF10138A), // ROS Blue
                          width: 1.5,
                        ),
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary,
                        textStyle: const TextStyle(
                          fontFamily: 'GlacialIndifference',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Continue as Guest'),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        // Navigate to the RegisterScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.tertiary,
                        textStyle: const TextStyle(
                          fontFamily: 'GlacialIndifference',
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      child: const Text("Don't have an account? Sign Up"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}