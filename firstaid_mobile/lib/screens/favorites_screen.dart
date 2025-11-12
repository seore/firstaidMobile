import 'package:flutter/material.dart';
import '../models/injury.dart';
import '../services/favorites.dart';
import 'injury_detail_screen.dart';

class FavouritesScreen extends StatefulWidget {
  final List<Injury> allInjuries;

  const FavouritesScreen({super.key, required this.allInjuries});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<String> _favNames = [];

  @override
  void initState() {
    super.initState();
    _loadFavs();
  }

  Future<void> _loadFavs() async {
    final favs = await Favorites.load();
    if (!mounted) return;
    setState(() {
      _favNames = favs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favourites = widget.allInjuries
        .where((injury) => _favNames.contains(injury.name))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      body: favourites.isEmpty
          ? const Center(
              child: Text(
                'No favourites yet.\nOpen an injury and tap the star icon to save it.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.separated(
              itemCount: favourites.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final injury = favourites[index];
                return ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: Text(injury.name),
                  subtitle: Text(
                    injury.steps.isNotEmpty
                        ? injury.steps.first.toString()
                        : '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InjuryDetailScreen(injury: injury),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
