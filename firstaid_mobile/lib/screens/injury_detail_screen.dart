import 'package:flutter/material.dart';
import '../models/injury.dart';
import '../widgets/injury_stepper.dart';
import '../services/emergency_service.dart';
import '../services/favorites.dart';         
import 'emergency_screen.dart';

class InjuryDetailScreen extends StatefulWidget {
  final Injury injury;

  const InjuryDetailScreen({super.key, required this.injury});

  @override
  State<InjuryDetailScreen> createState() => _InjuryDetailScreenState();
}

class _InjuryDetailScreenState extends State<InjuryDetailScreen> {
  bool _isFavourite = false;
  bool _favLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavouriteState();
  }

  Future<void> _loadFavouriteState() async {
    try {
      // adjust if your service uses a different name
      final isFav = await Favorites.isFavourite(widget.injury.name);
      if (!mounted) return;
      setState(() {
        _isFavourite = isFav;
        _favLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _favLoading = false;
      });
    }
  }

  Future<void> _toggleFavourite() async {
    try {
      // toggle and get new state (true = now favourited)
      final nowFav = await Favorites.toggle(widget.injury.name);
      if (!mounted) return;
      setState(() {
        _isFavourite = nowFav;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            nowFav
                ? 'Added "${widget.injury.name}" to favourites.'
                : 'Removed "${widget.injury.name}" from favourites.',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not update favourites: $e'),
        ),
      );
    }
  }

  Future<void> _handleEmergencyCall() async {
    const fallbackNumber = '112';
    final err = await EmergencyService.tryCall(fallbackNumber);

    if (!mounted) return;

    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not start an emergency call.'
            ' Please dial $fallbackNumber manually.\nError: $err',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attempting emergency call...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final injury = widget.injury;

    return Scaffold(
      appBar: AppBar(
        title: Text(injury.name),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 3,
        actions: [
          // Favourite toggle icon
          IconButton(
            tooltip: _isFavourite ? 'Remove from favourites' : 'Add to favourites',
            icon: _favLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    _isFavourite ? Icons.star : Icons.star_border,
                    color: _isFavourite
                        ? const Color.fromARGB(255, 255, 214, 0)
                        : Colors.white,
                  ),
            onPressed: _favLoading ? null : _toggleFavourite,
          ),

          // Emergency icon
          IconButton(
            icon: const Icon(Icons.call, color: Color.fromARGB(255, 233, 0, 0)),
            tooltip: 'Emergency',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmergencyScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: InjuryStepper(
                title: injury.name,
                steps: injury.steps,
                imageAsset: injury.imageName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
