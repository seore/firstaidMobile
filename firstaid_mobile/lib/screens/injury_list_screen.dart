import 'package:flutter/material.dart';
import '../models/injury.dart';
import 'injury_detail_screen.dart';

class InjuryListScreen extends StatefulWidget {
  final List<Injury> injuries;

  const InjuryListScreen({super.key, required this.injuries});

  @override
  State<InjuryListScreen> createState() => _InjuryListScreenState();
}

class _InjuryListScreenState extends State<InjuryListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.injuries.where((injury) {
      if (_query.isEmpty) return true;
      return injury.name.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Injuries'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search injury...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _query = val;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final injury = filtered[index];
                return ListTile(
                  leading: const Icon(Icons.health_and_safety),
                  title: Text(injury.name),
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
          ),
        ],
      ),
    );
  }
}
