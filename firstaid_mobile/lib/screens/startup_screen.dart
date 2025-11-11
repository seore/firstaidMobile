import 'package:flutter/material.dart';
import '../services/mode_service.dart';
import 'mode_selection.dart';
import 'home_screen.dart';
import 'emergency_screen.dart';

class StartupRouter extends StatefulWidget {
  const StartupRouter({super.key});

  @override
  State<StartupRouter> createState() => _StartupRouterState();
}

class _StartupRouterState extends State<StartupRouter> {
  bool _loading = true;
  Widget? _target;

  @override
  void initState() {
    super.initState();
    _decideStart();
  }

  Future<void> _decideStart() async {
    final mode = await ModeService.loadMode();

    Widget target;
    if (mode == 'emergency') {
      target = const EmergencyScreen();
    } else if (mode == 'learning') {
      target = const HomeScreen();
    } else {
      target = const ModeSelectionScreen();
    }

    if (!mounted) return;
    setState(() {
      _target = target;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _target == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return _target!;
  }
}
