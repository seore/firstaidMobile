import 'package:flutter/material.dart';
import '../services/injury_repository.dart';
import '../models/injury.dart';
import 'injury_list_screen.dart';
import 'favorites_screen.dart';
import 'injury_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Injury>> _futureInjuries;

  @override
  void initState() {
    super.initState();
    _futureInjuries = InjuryRepository.loadInjuries();
  }

  String _stepText(dynamic step) {
    if (step is String) return step;
    if (step is Map && step['text'] is String) return step['text'] as String;
    return step?.toString() ?? '';
  }

  Future<String> _buildDailyTip(List<Injury> injuries) async {
    if (injuries.isEmpty) {
      return 'Practice staying calm and checking for danger first.';
    }
    final first = injuries.first;
    final dynamic firstStep =
        first.steps.isNotEmpty ? first.steps.first : null;
    final tipText = firstStep != null ? _stepText(firstStep) : '';
    return 'Today’s tip - ${first.name}: $tipText';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aidly'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Injury>>(
        future: _futureInjuries,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error loading injuries: ${snapshot.error}'),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }

          final injuries = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // ----------------------------------------------------------
                // Emergency banner
                // ----------------------------------------------------------
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/emergency'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5E5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: const [
                        Icon(Icons.sos, color: Color.fromARGB(255, 247, 27, 11), size: 26),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'In an emergency, open Emergency Mode immediately.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.redAccent),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ----------------------------------------------------------
                // Daily tip card
                // ----------------------------------------------------------
                FutureBuilder<String>(
                  future: _buildDailyTip(injuries),
                  builder: (context, tipSnap) {
                    final tip = tipSnap.data ??
                        'Learn one small first aid skill today — it can save a life.';

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      color: const Color(0xFFF9F4FF),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb,
                                color: Colors.amber, size: 30),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tip,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 26),

                // ----------------------------------------------------------
                // Quick Access
                // ----------------------------------------------------------
                Text(
                  'Quick Access',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 30,
                  runSpacing: 12,
                  children: [
                    _FeatureCard(
                      icon: Icons.medical_information,
                      title: 'Browse Injuries',
                      subtitle: 'Step-by-step guides',
                      color: Colors.blueAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                InjuryListScreen(injuries: injuries),
                          ),
                        );
                      },
                    ),
                    _FeatureCard(
                      icon: Icons.star,
                      title: 'Favourites',
                      subtitle: 'Your saved guides',
                      color: const Color.fromARGB(255, 227, 216, 5),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                FavouritesScreen(allInjuries: injuries),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                // ----------------------------------------------------------
                // App Guides  
                // ----------------------------------------------------------
                Text(
                  'Popular Guides',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.shade50,
                      child: const Icon(Icons.emergency, color: Colors.red),
                    ),
                    title: const Text('Emergency Mode'),
                    subtitle: const Text('Fast access to calling help + key steps.'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, '/emergency'),
                  ),
                ),
                const SizedBox(height: 6),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: const Icon(Icons.dialpad, color: Colors.blue),
                    ),
                    title: const Text('Emergency Dial Pad'),
                    subtitle: const Text('Dial any number quickly in emergencies.'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, '/dialer'),
                  ),
                ),

                const SizedBox(height: 14),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: Colors.green.shade50,
                  child: const ListTile(
                    leading: Icon(Icons.visibility, color: Colors.green),
                    title: Text('Check for danger first'),
                    subtitle: Text(
                      'Before helping, make sure the scene is safe for you and others.',
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: Colors.orange.shade50,
                  child: const ListTile(
                    leading: Icon(Icons.health_and_safety, color: Colors.orange),
                    title: Text('Protect yourself'),
                    subtitle: Text(
                      'Use gloves or clean cloths when possible to avoid contact with blood.',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color.withOpacity(0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
