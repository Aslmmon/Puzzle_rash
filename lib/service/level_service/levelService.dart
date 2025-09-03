// lib/service/level_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/level_config.dart';

class LevelService {
  // Generates a list of all available levels
  List<LevelConfig> generateLevels() {
    final levels = <LevelConfig>[];
    const themes = ['palestine', 'islam', 'animals', 'fruits', 'sports'];

    // You can define a pattern to increase difficulty
    for (int i = 1; i <= 20; i++) {
      // Let's create 20 levels for now
      int rows = 2;
      int cols = 2;
      final themeKey = themes[(i - 1) % themes.length];

      // Increase grid size based on a faster progression
      if (i > 4) {
        // Start increasing grid size after level 4
        rows = 2;
        cols = 3;
      }
      if (i > 8) {
        // Increase again after level 8
        rows = 3;
        cols = 3;
      }
      if (i > 12) {
        // And again after level 12
        rows = 3;
        cols = 4;
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
