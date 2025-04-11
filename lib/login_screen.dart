/*
* Author: Cole Brito
* ENG4001_020
* Basic login screen and autherization of users logic
*/

import 'package:flutter/material.dart';
import 'package:flutter_application_2/admin_dashboard.dart';
import 'package:flutter_application_2/member_dashboard.dart';
import 'mock_users.dart';

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

    final user = mockUsers.firstWhere(
      (u) => u['username'] == username && u['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      final role = user['role'];

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      } else if (role == 'member') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MemberDashboard()),
        );
      } else {
        _showError('Invalid role');
      }
    } else {
      _showError('Invalid username or password');
    }
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
          ],
        ),
      ),
    );
  }
}
