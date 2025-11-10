import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import '../models/injury.dart';
import 'injury_detail_screen.dart';
import 'emergency_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
        steps: stepsList != null
    ? stepsList.map((e) {
        if (e is Map<String, dynamic>) return e;
        return {'text': e.toString()}; // convert old String steps
      }).toList()
    : [
        {'text': 'No steps available'}
      ],

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
        leading: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutScreen()),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () async {
              await Navigator.pushNamed(context, '/profile');
            }
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Color.fromARGB(255, 224, 1, 1)),
            tooltip: 'Emergency',
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => EmergencyScreen()),
            )
          ),
        ],
      ),
      body: Column(
          children: [
            Padding (
              padding: const EdgeInsets.all(16),
              child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search for an injury...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
              ),
            ),
            //const SizedBox(height: 20),
            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredInjuries.length + 1,
                itemBuilder: (context, index) {
                  if (index < filteredInjuries.length) {
                    final currentInjury = filteredInjuries[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(currentInjury.name),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InjuryDetailScreen(injury: currentInjury),
                          ),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ); 
  }
}
