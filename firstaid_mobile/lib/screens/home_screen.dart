import 'package:flutter/material.dart';
import '../services/injury_repository.dart';
import '../models/injury.dart';
import '../services/favorites.dart';
import 'injury_list_screen.dart';
import 'favorites_screen.dart';
import 'quiz_screen.dart';
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

  Future<String> _buildDailyTip(List<Injury> injuries) async {
    if (injuries.isEmpty) return 'Practice staying calm and checking for danger first.';

    // Simple “tip”: pick first step of first injury, or something short
    final first = injuries.first;
    final firstStep = first.steps.isNotEmpty ? first.steps.first.toString() : '';
    return 'Today’s tip - ${first.name}: $firstStep';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aidly'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Emergency mode',
            icon: const Icon(Icons.emergency_share),
            onPressed: () {
              Navigator.pushNamed(context, '/emergency');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Injury>>(
        future: _futureInjuries,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.hasError) {
              return Center(child: Text('Error loading injuries: ${snapshot.error}'));
            }
            return const Center(child: CircularProgressIndicator());
          }

          final injuries = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // Daily tip
                FutureBuilder<String>(
                  future: _buildDailyTip(injuries),
                  builder: (context, tipSnap) {
                    final tip = tipSnap.data ??
                        'Learn one small first aid skill today – it can save a life.';
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb, color: Colors.amber, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tip,
                                style: const TextStyle(fontSize: 14, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Quick navigation cards
                Text(
                  'Learn & Practice',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 12,
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
                            builder: (_) => InjuryListScreen(injuries: injuries),
                          ),
                        );
                      },
                    ),
                    _FeatureCard(
                      icon: Icons.star,
                      title: 'Favourites',
                      subtitle: 'Your saved guides',
                      color: const Color.fromARGB(255, 255, 236, 64),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FavouritesScreen(allInjuries: injuries),
                          ),
                        );
                      },
                    ),
                    _FeatureCard(
                      icon: Icons.quiz,
                      title: 'Quiz Yourself',
                      subtitle: 'Short practice quizzes',
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(injuries: injuries),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Recently viewed / featured injuries
                Text(
                  'Popular Guides',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),

                ...injuries.take(4).map((injury) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: const Icon(Icons.health_and_safety),
                    ),
                    title: Text(injury.name),
                    subtitle: Text(
                      injury.steps.isNotEmpty
                          ? injury.steps.first.toString()
                          : 'Open to view steps.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/injuryDetail',
                        arguments: injury,
                      );
                    },
                  );
                }),
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
      width: 160,
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
                  color: color.darken(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
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

// handy extension for darker shade
extension on Color {
  Color darken([double amount = .2]) {
    final hsl = HSLColor.fromColor(this);
    final hslDark =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
