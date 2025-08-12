/*
* ROSS Game Management Project
* Author: Cole Brito
* Contributors: Bivin, Jean Luc, Cole Brito
* Main entry point for the ROS Racket Sports Management App
*/

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_2/services/notification_service.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

/// Main function - Entry point of the application
/// Initializes Firebase and starts the Flutter app
void main() async {
  // Initialize Flutter framework before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific configuration
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize comprehensive notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Start the Flutter application
  runApp(const ROSGameApp());
}

/// Main application widget for ROS Racket Sports Management
class ROSGameApp extends StatelessWidget {
  const ROSGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App configuration
      title: 'ROS Racket Sports',
      debugShowCheckedModeBanner: false,

      // Theme configuration (imported from theme files)
      theme: AppTheme.light, // Light theme with gradients
      //uncomment the following line for dark theme
      //darkTheme: AppTheme.dark, // Dark theme (gradient-safe)
      themeMode: ThemeMode.system, // Auto-switch based on device
      // Start with login screen
      home: const LoginScreen(),
    );
  }
}
