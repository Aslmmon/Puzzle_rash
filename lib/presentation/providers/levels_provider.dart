import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/data/cache/progress_storage.dart';
import 'package:puzzle_rush/presentation/providers/storageProvider.dart';
import '../../domain/entities/level_config.dart';

final levelsProvider = StateNotifierProvider<LevelsNotifier, List<LevelConfig>>(
  (ref) => LevelsNotifier(ref.read(progressStorageProvider)),
);

class LevelsNotifier extends StateNotifier<List<LevelConfig>> {
  final ProgressStorage storage;

  LevelsNotifier(this.storage) : super([]) {
    _initLevels();
  }

  Future<void> _initLevels() async {
    final initialLevels = [
      LevelConfig(id: 1, rows: 2, cols: 2, themeKey: 'palestine'),
      LevelConfig(id: 2, rows: 2, cols: 3, themeKey: 'palestine'),
      LevelConfig(id: 3, rows: 3, cols: 3, themeKey: 'islam'),
    ];

    final completed = await storage.getCompletedLevels();

    state =
        initialLevels.map((level) {
          if (level.id == 1 || completed.contains(level.id - 1)) {
            return level.copyWith(isLocked: false);
          }
          return level;
        }).toList();
  }

  Future<void> markLevelCompleted(int id) async {
    await storage.markLevelCompleted(id);

    state =
        state.map((level) {
          if (level.id == id + 1) return level.copyWith(isLocked: false);
          return level;
        }).toList();
  }

  LevelConfig getLevelById(int id) {
    return state.firstWhere(
          (l) => l.id == id,
      orElse: () => state.first,
    );
  }
}
