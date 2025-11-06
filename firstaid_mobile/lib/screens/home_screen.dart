import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
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
  List<Injury> injuries = [];
  String searchQuery = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadInjuries();
  }

  Future<void> loadInjuries() async {
  final String jsonString = await rootBundle.loadString('assets/injuries.json');
  final List<dynamic> jsonData = json.decode(jsonString);

  setState(() {
    injuries = jsonData.map((e) {
      final name = e['name'] as String?;
      final imageName = e['imageName'] as String?;
      final stepsList = e['steps'] as List<dynamic>?;

      return Injury(
        name: name ?? 'Unknown Injury',
        imageName: imageName ?? 'default.png',
        steps: stepsList != null ? stepsList.cast<String>() : ['No steps available'],
      );
    }).toList();
    loading = false;
  });
}


  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final filteredInjuries = injuries
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
          
            const SizedBox(height: 20),
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
    )
  );
  }
}
