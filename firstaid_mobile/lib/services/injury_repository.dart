import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/injury.dart';

class InjuryRepository {
  static List<Injury>? _cache;

  static Future<List<Injury>> loadInjuries() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/injuries.json');
    final List decoded = jsonDecode(raw) as List;

    final result = <Injury>[];
    for (var i = 0; i < decoded.length; i++) {
      final item = decoded[i];
      if (item is Map<String, dynamic>) {
        try {
          result.add(Injury.fromJson(item));
        } catch (e) {
          result.add(Injury(
            name: 'Invalid entry #$i',
            imageName: null,
            steps: ['Unable to parse this entry. Error: $e'], 
          ));
        }
      } else {
        result.add(Injury(
          name: 'Invalid entry #$i (not an object)',
          imageName: null,
          steps: ['Expected a JSON object but got ${item.runtimeType}.'],
        ));
      }
    }

    _cache = result;
    return _cache!;
  }
}
