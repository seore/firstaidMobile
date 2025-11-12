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
          // Use a VALID step map instead of a String!
          result.add(Injury(
            name: "Invalid entry #$i",
            imageName: null,
            steps: [
              {
                "text": "Unable to parse entry. Error: $e",
                "imageName": null,
                "timerSeconds": null,
              }
            ],
          ));
        }
      } else {
        // Use a VALID map here too
        result.add(Injury(
          name: "Invalid entry #$i (not an object)",
          imageName: null,
          steps: [
            {
              "text": "Expected an object, got ${item.runtimeType}",
              "imageName": null,
              "timerSeconds": null,
            }
          ],
        ));
      }
    }

    _cache = result;
    return _cache!;
  }
}
