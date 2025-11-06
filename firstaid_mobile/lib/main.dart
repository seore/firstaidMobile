import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/injury_detail_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/about_screen.dart';
import 'models/injury.dart';

void main() {
  runApp(FirstAidApp());
}

class FirstAidApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FirstAid Pocket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        fontFamily: 'Poppins',
      ),
      home: HomeScreen(),
      routes: {
        '/emergency': (context) => EmergencyScreen(),
        '/about': (context) => AboutScreen(),
      },
    );
  }
}
