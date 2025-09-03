// lib/service/level_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/level_config.dart';

class LevelService {
  // Generates a list of all available levels
  List<LevelConfig> generateLevels() {
    final levels = <LevelConfig>[];
    const themes = ['palestine', 'islam', 'animals', 'fruits', 'sports'];

    // You can define a pattern to increase difficulty
    for (int i = 1; i <= 30; i++) {
      // Let's create 20 levels for now
      int rows = 2;
      int cols = 2;
      final themeKey = themes[(i - 1) % themes.length];

      // New difficulty progression for 30 levels
      if (i <= 5) {
        rows = 2;
        cols = 2;
      } else if (i <= 10) {
        rows = 2;
        cols = 3;
      } else if (i <= 15) {
        rows = 3;
        cols = 3;
      } else if (i <= 20) {
        rows = 3;
        cols = 4;
      } else if (i <= 25) {
        rows = 4;
        cols = 4; // A new, more challenging tier
      } else {
        rows = 4;
        cols = 5; // The final, most difficult tier
      }

      levels.add(
        LevelConfig(id: i, rows: rows, cols: cols, themeKey: themeKey),
      );
    }
    return levels;
  }
}

// And the new Riverpod provider to make it available
final levelServiceProvider = Provider<LevelService>((ref) => LevelService());
