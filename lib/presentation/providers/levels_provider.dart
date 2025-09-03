import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/data/cache/progress_storage.dart';
import 'package:puzzle_rush/presentation/providers/storageProvider.dart';
import 'package:puzzle_rush/service/level_service/levelService.dart';
import '../../domain/entities/level_config.dart';

final levelsProvider = StateNotifierProvider<LevelsNotifier, List<LevelConfig>>(
  (ref) {
    return LevelsNotifier(
      ref.read(progressStorageProvider),
      ref.read(levelServiceProvider), // Inject the new service
    );
  },
);

class LevelsNotifier extends StateNotifier<List<LevelConfig>> {
  final ProgressStorage storage;
  final LevelService levelService;

  LevelsNotifier(this.storage, this.levelService) : super([]) {
    _initLevels();
  }

  Future<void> _initLevels() async {
    final allLevels = levelService.generateLevels(); // Use the service to get all levels
    final completed = await storage.getCompletedLevels();

    state = allLevels.map((level) {
          if (level.id == 1 || completed.contains(level.id - 1)) {
            return level.copyWith(isLocked: false);
          }
          return level;
        }).toList();
  }

  Future<void> markLevelCompleted(int id) async {
    await storage.markLevelCompleted(id);
    state = state.map((level) {
          if (level.id == id + 1) return level.copyWith(isLocked: false);
          return level;
        }).toList();
  }

  LevelConfig getLevelById(int id) {
    return state.firstWhere(
      (l) => l.id == id,
      orElse: () {
        // Handle cases where the level ID is out of range
        return state.first;
      },
    );
  }
}
