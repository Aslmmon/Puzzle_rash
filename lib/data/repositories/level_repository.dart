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
      Level(
        id: '1-1', // Simple Square (Good for basic connection)
        isLocked: false,
        connectDotsData: [
          {'x': 100.0, 'y': 100.0}, {'x': 200.0, 'y': 100.0},
          {'x': 200.0, 'y': 200.0}, {'x': 100.0, 'y': 200.0},
        ],
      ),
      Level(
        id: '1-2', // Simple Triangle (Basic connection)
        isLocked: true,
        connectDotsData: [
          {'x': 150.0, 'y': 100.0}, {'x': 100.0, 'y': 200.0},
          {'x': 200.0, 'y': 200.0},
        ],
      ),
      // Your existing 1-3 was good, let's keep it or modify slightly
      Level(
        id: '1-3', // Tests non-obvious connection order, longer path
        isLocked: true,
        connectDotsData: [
          {'x': 100.0, 'y': 100.0}, {'x': 100.0, 'y': 200.0},
          {'x': 100.0, 'y': 300.0}, // Collinear start
          {'x': 250.0, 'y': 100.0},
          {'x': 250.0, 'y': 300.0},
        ],
      ),
      Level(
        id: '1-4', // Test for "Passing Through Other Dots" & Potential Self-Intersection
        isLocked: true,
        connectDotsData: [
          //   A-----B
          //   |  C  |   <- C is the intermediate dot
          //   D-----E
          {'x': 100.0, 'y': 100.0}, // A
          {'x': 300.0, 'y': 100.0}, // B
          {'x': 200.0, 'y': 150.0}, // C (The "other" dot)
          {'x': 100.0, 'y': 200.0}, // D
          {'x': 300.0, 'y': 200.0}, // E
          // Try connecting A-E directly (should fail due to C if rules are strict)
          // Or A-B-E-D-A (potential self-intersection)
        ],
      ),

      Level(
        id: '1-5-alt', // "Figure Eight" (alternative, avoids reusing a dot instance in data)
        // This requires the player to draw lines that cross.
        isLocked: true,
        connectDotsData: [
          {'x': 100.0, 'y': 100.0}, // Top-left
          {'x': 300.0, 'y': 300.0}, // Bottom-right
          {'x': 100.0, 'y': 300.0}, // Bottom-left
          {'x': 300.0, 'y': 100.0}, // Top-right
          // Path: (100,100) -> (300,300) -> (100,300) -> (300,100) -> (100,100)
          // The segments (100,100)-(300,300) and (100,300)-(300,100) will intersect.
        ],
      ),
      Level(
        id: '1-6', // Minimal Dots (Line)
        isLocked: true,
        connectDotsData: [
          {'x': 100.0, 'y': 150.0},
          {'x': 250.0, 'y': 150.0},
        ],
      ),
      Level(
        id: '1-7', // Asymmetric "U" Shape - Longer path
        isLocked: true,
        connectDotsData: [
          {'x': 100.0, 'y': 100.0}, {'x': 200.0, 'y': 100.0},
          {'x': 200.0, 'y': 200.0}, {'x': 200.0, 'y': 300.0},
          {'x': 100.0, 'y': 300.0},
        ],
      ),
      Level(
        id: '1-8', // Spiral In - Test for tight turns and potential self-intersection
        isLocked: true,
        connectDotsData: [
          {'x': 100.0, 'y': 100.0}, {'x': 300.0, 'y': 100.0},
          {'x': 300.0, 'y': 300.0}, {'x': 100.0, 'y': 300.0},
          {'x': 100.0, 'y': 200.0}, {'x': 200.0, 'y': 200.0}, // Center of spiral
        ],
      ),
      Level(
        id: '1-9', // Test "Passing Through Other Dots" - Collinear case
        isLocked: true,
        connectDotsData: [
          // A -- B -- C -- D
          {'x': 50.0, 'y': 150.0},  // A
          {'x': 150.0, 'y': 150.0}, // B (intermediate)
          {'x': 250.0, 'y': 150.0}, // C (intermediate)
          {'x': 350.0, 'y': 150.0}, // D
          // Player might try A -> D directly. Should be invalid if passing through B or C is checked.
          // Correct path would need to visit B and C, e.g. A-B-C-D or A-D (if only extreme dots needed to be connected).
          // Assuming all dots must be connected: A-B-C-D is the only way.
        ],
      ),
      Level(
        id: '1-10', // More Complex Shape - "House"
        isLocked: true,
        connectDotsData: [
          // Roof peak
          {'x': 200.0, 'y': 50.0},
          // Roof corners
          {'x': 100.0, 'y': 150.0}, {'x': 300.0, 'y': 150.0},
          // Base corners
          {'x': 100.0, 'y': 250.0}, {'x': 300.0, 'y': 250.0},
        ],
      ),
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
