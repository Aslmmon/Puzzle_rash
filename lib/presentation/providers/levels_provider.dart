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
    final allLevels =
        levelService.generateLevels(); // Use the service to get all levels
    final completed = await storage.getCompletedLevels();
    final levelsWithStars = <LevelConfig>[];
    for (var level in allLevels) {
      final stars = await storage.getStars(
        level.id,
      ); // <-- Fetch the star count
      final isLocked = level.id != 1 && !completed.contains(level.id - 1);

      levelsWithStars.add(
        level.copyWith(
          isLocked: isLocked,
          stars: stars, // <-- Add the stars to the level
        ),
      );
    }
    state = levelsWithStars;
  }

  Future<void> markLevelCompleted(int id) async {
    await storage.markLevelCompleted(id);
    // We need to rebuild the state list to trigger a UI update
    final updatedList =
        state.map((level) {
          if (level.id == id + 1) {
            return level.copyWith(isLocked: false);
          }
          return level;
        }).toList();

    // Set the new state
    state = updatedList;
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
