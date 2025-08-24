// lib/data/repositories/level_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/level.dart'; // Import your Level model

class LevelRepository {
  // Simulate a database or API call with a delay
  Future<List<Level>> fetchLevels() async {
    // In a real app, this would fetch from Firebase Firestore, a local DB, or an API
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network latency

    // For now, return a hardcoded list.
    // This could also be where you define the default structure of your levels.
    return [
      Level(id: 'pack1_lvl1', isLocked: false, stars: 0),
      Level(id: 'pack1_lvl2', isLocked: true, stars: 0),
      Level(id: 'pack1_lvl3', isLocked: true, stars: 0),
      Level(id: 'pack1_lvl4', isLocked: true, stars: 0),
      Level(id: 'pack1_lvl5', isLocked: true, stars: 0),
      Level(id: 'pack2_lvl1', isLocked: true, stars: 0),
      // ... more levels
    ];
  }

  // Simulate saving level progress
  Future<void> saveLevelProgress(Level level) async {
    // In a real app, this would update the data in Firebase Firestore or local DB
    await Future.delayed(
      const Duration(milliseconds: 200),
    ); // Simulate network latency
    print(
      'Level progress saved for ${level.id}: Stars - ${level.stars}, Locked - ${level.isLocked}',
    );
    // No actual saving logic here yet, just a placeholder
  }

  Future<void> unlockNextLevel(
    String currentLevelId,
    List<Level> allLevels,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final currentIndex = allLevels.indexWhere(
      (lvl) => lvl.id == currentLevelId,
    );
    if (currentIndex != -1 && currentIndex + 1 < allLevels.length) {
      final nextLevel = allLevels[currentIndex + 1];
      if (nextLevel.isLocked) {
        // In a real app, you'd save this change.
        print('Unlocking level: ${nextLevel.id}');
        // For simulation, we're not changing the state here directly,
        // the StateNotifier would handle that based on this repository's actions.
      }
    }
  }

  // You might add more methods here like:
  // - fetchLevelById(String id)
  // - updateLevel(Level level)
  // - resetAllLevels()
}

// Optional: Provider for the repository itself if it has dependencies or you want to mock it
final levelRepositoryProvider = Provider<LevelRepository>((ref) {
  return LevelRepository();
});
