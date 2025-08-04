import 'package:flutter/material.dart';
// Added by Jean Luc: Firebase initialization
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';

void main() async {
  // Ensure that Flutter is initialized before using Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'GlacialIndifference',
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: 22,
            color: Colors.black,
          ),
          titleLarge: TextStyle(
            fontFamily: 'bebasneuecyrillic',
            fontSize: 24,
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontFamily: 'bebasneuecyrillic',
            fontSize: 20,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'GlacialIndifference',
            fontSize: 16,
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            fontFamily: 'GlacialIndifference',
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF10138A), // ROS Blue
          onPrimary: Colors.white,
          onSurface: Colors.black,
          onSurfaceVariant: Colors.black87,
          secondary: Color(0xFF10138A),
          tertiary: Colors.black,
        ),

        // Uncomment the following lines to enable dark theme

        //    darkTheme: ThemeData(
        //     useMaterial3: true,
        //     brightness: Brightness.dark,
        //     scaffoldBackgroundColor: Colors.black,
        //     fontFamily: 'GlacialIndifference',
        //     textTheme: const TextTheme(
        //       headlineSmall: TextStyle(fontFamily: 'BebasNeue', fontSize: 22, color: Colors.white),
        //       titleLarge: TextStyle(fontFamily: 'bebasneuecyrillic', fontSize: 24, color: Colors.white),
        //       titleMedium: TextStyle(fontFamily: 'bebasneuecyrillic', fontSize: 20, color: Colors.white),
        //       bodyLarge: TextStyle(fontFamily: 'GlacialIndifference', fontSize: 16, color: Colors.white),
        //       bodySmall: TextStyle(fontFamily: 'GlacialIndifference', fontSize: 14, color: Colors.white),
        //     ),
        //     colorScheme: ColorScheme.dark(
        //       primary: Color(0xFF10138A), // ROS Blue
        //       onPrimary: Colors.white,
        //       onSurface: Colors.white,
        //       onSurfaceVariant: Colors.white70,
        //       secondary: Color(0xFF10138A),
        //       tertiary: Colors.white,
        //     ),
        //     appBarTheme: const AppBarTheme(centerTitle: true),
        //   ),

        // themeMode: ThemeMode.system,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const LoginScreen(),
    );
  }
}
