import 'package:aidly/models/injury.dart';
import 'package:aidly/screens/phone_dialer.dart';
import 'package:aidly/screens/startup_screen.dart';
import 'package:aidly/services/notification_service.dart';
import 'package:aidly/services/push_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/injury_detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/about_screen.dart';
import 'screens/profile_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(FirstAidApp());
  PushService.init();
  NotificationService.init();
}

class FirstAidApp extends StatelessWidget {
  const FirstAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aidly',
      debugShowCheckedModeBanner: false,
      // App Localizations
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('yo'),
        Locale('fr'),
      ],
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 0, 0, 0),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
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
      home: const StartupRouter(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/emergency': (context) => EmergencyScreen(),
        '/dialer': (context) => PhoneDialerScreen(),
        '/about': (context) => AboutScreen(),
        '/profile': (context) => const ProfileScreen(),
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/injuryDetail') {
          final injury = settings.arguments as Injury;
          return MaterialPageRoute(
            builder: (_) => InjuryDetailScreen(injury: injury)
          );  
        }
        return null;
      },
    );
  }
}


