import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Manager',
      debugShowCheckedModeBanner: false,

      // LIGHT THEME
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'GlacialIndifference',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10138A),
          primary: const Color(0xFF10138A), // ROS Blue
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),

      // DARK THEME
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'GlacialIndifference',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10138A),
          primary: const Color(0xFF10138A), // ROS Blue
          brightness: Brightness.dark,
        ),
        
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),

      themeMode: ThemeMode.system,
      home: const LoginScreen(),
    );
  }
}
