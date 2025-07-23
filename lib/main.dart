import 'package:flutter/material.dart';
// Added by Jean Luc: Firebase initialization
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';

void main() async {
  // Added by Jean Luc
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase connection to our flutter app

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF10138A),
        brightness: Brightness.light,
        fontFamily: 'GlacialIndifference',
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF10138A),
        brightness: Brightness.dark,
        fontFamily: 'GlacialIndifference',
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
    );
  }
}
