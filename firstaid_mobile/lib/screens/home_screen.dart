import 'package:flutter/material.dart';
import '../models/injury.dart';
import 'injury_detail_screen.dart';
import 'emergency_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Injury> injuries = [
    Injury(name: "Burns", steps: ["Cool the burn", "Cover with sterile cloth"]),
    Injury(name: "Cuts", steps: ["Stop bleeding", "Clean wound", "Apply bandage"]),
    Injury(name: "Nosebleed", steps: ["Lean forward", "Pinch nose 10 mins"]),
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    var filteredInjuries = injuries
        .where((i) => i.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("FirstAid Pocket"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search for an injury...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredInjuries.length,
                itemBuilder: (context, index) {
                  final injury = filteredInjuries[index];
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(injury.name),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InjuryDetailScreen(injury: injury),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmergencyScreen()),
              ),
              icon: const Icon(Icons.call),
              label: const Text("Emergency Help"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
