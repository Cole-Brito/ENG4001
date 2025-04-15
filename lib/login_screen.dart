/*
* Author: Cole Brito
* ENG4001_020
* Basic login screen and autherization of users logic
*/

import 'package:flutter/material.dart';
import 'package:flutter_application_2/admin_dashboard.dart';
import 'package:flutter_application_2/member_dashboard.dart';
import 'package:flutter_application_2/models/user.dart';
import 'package:flutter_application_2/scheduled_games_screen.dart';
import 'data/mock_users.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Text field editers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Basic login logic and autherization logic
  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final userMap = mockUsers.firstWhere(
      (u) => u['username'] == username && u['password'] == password,
      orElse: () => {},
    );

    if (userMap.isNotEmpty) {
      final role = userMap['role'];

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      } else if (role == 'member') {
        // Converting map into a User object
        final user = User(username: userMap['username']!, isAdmin: false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MemberDashboard(user: user)),
        );
      } else {
        _showError('Invalid role');
      }
    } else {
      _showError('Invalid username or password');
    }
  }

  // Guest Login -- Can only see the sechduled games for now
  void _guestLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScheduledGamesScreen()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  //--------------------- UI CODE BELOW ---------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _login, child: Text('Login')),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _guestLogin, child: Text('Guest Login')),
          ],
        ),
      ),
    );
  }
}
