// lib/data/cache/progress_storage.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProgressStorage {
  static const String _coinsKey = 'coins';
  static const String _completedLevelsKey = 'completed_levels';
  static const String _inventoryKey = 'player_inventory';

  final SharedPreferences _prefs;

  ProgressStorage(this._prefs);

  /// Retrieves the total number of coins.
  int getCoins() {
    return _prefs.getInt(_coinsKey) ?? 0;
  }

  /// Adds coins to the total.
  Future<void> addCoins(int coins) async {
    final currentCoins = getCoins();
    await _prefs.setInt(_coinsKey, currentCoins + coins);
  }

  /// Retrieves a list of completed level IDs.
  List<int> getCompletedLevels() {
    final completed = _prefs.getStringList(_completedLevelsKey) ?? [];
    return completed.map(int.parse).toList();
  }

  /// Marks a level as completed.
  Future<void> markLevelCompleted(int levelId) async {
    final completed = getCompletedLevels();
    if (!completed.contains(levelId)) {
      completed.add(levelId);
      await _prefs.setStringList(
        _completedLevelsKey,
        completed.map((e) => e.toString()).toList(),
      );
    }
  }

  /// Saves the stars earned for a specific level.
  Future<void> saveStars(int levelId, int stars) async {
    await _prefs.setInt('stars_$levelId', stars);
  }

  /// Retrieves the stars earned for a specific level.
  int getStars(int levelId) {
    return _prefs.getInt('stars_$levelId') ?? 0;
  }

  // New method to save the inventory Map
  Future<void> saveInventory(Map<String, int> inventory) async {
    final jsonString = json.encode(inventory);
    await _prefs.setString(_inventoryKey, jsonString);
  }

  // New method to load the inventory Map
  Map<String, int> getInventory() {
    final jsonString = _prefs.getString(_inventoryKey);
    if (jsonString != null) {
      return Map<String, int>.from(json.decode(jsonString));
    }
    return {};
  }
}
