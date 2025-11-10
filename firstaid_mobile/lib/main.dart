import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/injury_detail_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/about_screen.dart';
import 'screens/profile_screen.dart';
import 'models/injury.dart';

void main() {
  runApp(FirstAidApp());
}

class FirstAidApp extends StatelessWidget {
  const FirstAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aidly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 33, 141, 165),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 33, 141, 165),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)
            ),
          ),
        ),
      ),
      home: HomeScreen(),
      routes: {
        '/emergency': (context) => EmergencyScreen(),
        '/about': (context) => AboutScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}


