import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/level.dart';
import '../repositories/level_repository.dart';

class LevelNotifier extends StateNotifier<List<Level>> {
  final LevelRepository _repository;

  LevelNotifier(this._repository) : super([]) {
    // Start with an empty list
    _loadLevels(); // Load levels when notifier is created
  }

  Future<void> _loadLevels() async {
    state = await _repository.fetchLevels();
    // Potentially, ensure the first level is unlocked if not already handled by repository
    if (state.isNotEmpty && state.first.isLocked) {
      state = [state.first.copyWith(isLocked: false), ...state.skip(1)];
    }
  }

  // ... other methods would also interact with _repository ...
  void completeLevel(String completedLevelId, int starsEarned) async {
    Level? updatedLevel;
    int completedLevelIndex = -1;

    List<Level> newState =
        state.map((level) {
          if (level.id == completedLevelId) {
            updatedLevel = level.copyWith(stars: starsEarned, isLocked: false);
            return updatedLevel!;
          }
          return level;
        }).toList();

    if (updatedLevel != null) {
      await _repository.saveLevelProgress(updatedLevel!);
      // Unlock next level logic (could also be a repository method)
      completedLevelIndex = newState.indexWhere(
        (l) => l.id == completedLevelId,
      );
      if (completedLevelIndex != -1 &&
          completedLevelIndex + 1 < newState.length) {
        Level nextLevel = newState[completedLevelIndex + 1];
        if (nextLevel.isLocked) {
          newState[completedLevelIndex + 1] = nextLevel.copyWith(
            isLocked: false,
          );
          // Potentially save the unlocked state of nextLevel too via repository
          await _repository.saveLevelProgress(
            newState[completedLevelIndex + 1],
          );
        }
      }
    }
    state = newState;
  }
}

final levelProvider = StateNotifierProvider<LevelNotifier, List<Level>>((ref) {
  final repository = ref.watch(
    levelRepositoryProvider,
  ); // Assuming levelRepositoryProvider exists
  return LevelNotifier(repository);
});
