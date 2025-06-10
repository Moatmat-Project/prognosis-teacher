import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class ResultCache {
  static const String _key = 'cached_results';

  // Store a new result to the list
  Future<void> storeResult(Uint8List result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> allResults = prefs.getStringList(_key) ?? [];
    String encoded = base64Encode(result);
    allResults.add(encoded);
    await prefs.setStringList(_key, allResults);
  }

  // Retrieve all results
  Future<List<Uint8List>> retrieveResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedResults = prefs.getStringList(_key) ?? [];
    List<Uint8List> results = encodedResults.map((str) => base64Decode(str)).toList();
    return results;
  }

  // Delete a specific result
  Future<void> deleteResult(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> results = prefs.getStringList(_key) ?? [];
    if (index >= 0 && index < results.length) {
      results.removeAt(index);
      await prefs.setStringList(_key, results);
    }
  }

  // Clear all results
  Future<void> clearResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
