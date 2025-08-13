/*
* Author: Cole Brito
* UI Author : Bivin Job
* Edited by: Jean Luc
* ENG4001_020
* Basic login screen and authentication logic
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth; // Jean Luc
import 'package:cloud_firestore/cloud_firestore.dart'; // Jean Luc
import 'admin_dashboard.dart';
import 'member_dashboard.dart';
import 'register_screen.dart';
import 'guest_screen.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Jean Luc - Login using Firebase Authentication and route based on Firestore role
  void _login() async {
    final String usernameOrEmail = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      String emailToUse = usernameOrEmail;

      // Check if input is a username (not an email format)
      if (!usernameOrEmail.contains('@')) {
        // Search for user by username in Firestore to get their email
        final usernameQuery =
            await FirebaseFirestore.instance
                .collection('users')
                .where('username', isEqualTo: usernameOrEmail)
                .limit(1)
                .get();

        if (usernameQuery.docs.isEmpty) {
          _showError('Username not found');
          return;
        }

        // Get the email from the user document
        emailToUse = usernameQuery.docs.first.data()['email'] ?? '';
        if (emailToUse.isEmpty) {
          _showError('No email associated with this username');
          return;
        }
      }

      // Jean Luc - Authenticate with Firebase Auth using email
      final credential = await fb_auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailToUse, password: password);

      // Jean Luc - Fetch the user role from Firestore based on UID
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(credential.user!.uid)
              .get();

      final isAdmin = userDoc.data()?['isAdmin'] ?? false;
      final username =
          userDoc.data()?['username'] ?? credential.user!.email ?? 'Unknown';

      // Jean Luc - Create app-level User object with role info
      final User user = User(
        username: username, // Use custom username from Firestore
        isAdmin: isAdmin,
        email: credential.user!.email, // Set email field for database users
      );

      // Jean Luc - Redirect user based on role

      final Widget dashboard =
          isAdmin ? AdminDashboard(user: user) : MemberDashboard(user: user);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (BuildContext context) => dashboard),
      );
    } catch (e) {
      _showError('Login failed: ${e.toString().split(']').last}');
    }
  }

  void _guestLogin() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const GuestScreen(),
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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromRGBO(0, 0, 0, 0.1),
                    const Color.fromRGBO(0, 0, 0, 0.5),
                    const Color.fromRGBO(16, 19, 138, 0.3),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isSmallScreen ? double.infinity : 450,
                ),
                child: Card(
                  elevation: 12,
                  shadowColor: const Color.fromRGBO(16, 19, 138, 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: Theme.of(context).colorScheme.surface.withOpacity(
                    0.95,
                  ), // Not a Color, keep as is
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color.fromRGBO(16, 19, 138, 0.1),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Image.asset(
                            'assets/icons/ROS_Logo-new.png',
                            height: isSmallScreen ? 60 : 100,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 40),
                          Text(
                            'Welcome Back!',
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to continue',
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 48),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username or Email',
                              hintText: 'Enter your username or email',
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: const Color.fromRGBO(16, 19, 138, 0.7),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: const Color(
                                    0xFF10138A,
                                  ).withOpacity(0.2), // Not a Color, keep as is
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFF10138A),
                                  width: 2.5,
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(
                                0xFF10138A,
                              ).withOpacity(0.05), // Not a Color, keep as is
                              labelStyle: TextStyle(
                                color: const Color.fromRGBO(16, 19, 138, 0.8),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: const Color.fromRGBO(16, 19, 138, 0.7),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: const Color(
                                    0xFF10138A,
                                  ).withOpacity(0.2), // Not a Color, keep as is
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFF10138A),
                                  width: 2.5,
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(
                                0xFF10138A,
                              ).withOpacity(0.05), // Not a Color, keep as is
                              labelStyle: TextStyle(
                                color: const Color.fromRGBO(16, 19, 138, 0.8),
                              ),
                            ),
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _login(),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: const Color(0xFF10138A),
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: const Color(
                                0xFF10138A,
                              ).withOpacity(0.4), // Not a Color, keep as is
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: _guestLogin,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: const BorderSide(
                                color: Color(0xFF10138A),
                                width: 2,
                              ),
                              foregroundColor: const Color(0xFF10138A),
                              backgroundColor: Colors.transparent,
                            ),
                            child: const Text(
                              'Continue as Guest',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF10138A),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
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
          ),
        ],
      ),
    );
  }
}
