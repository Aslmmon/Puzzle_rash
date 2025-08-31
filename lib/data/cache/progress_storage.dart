import 'package:shared_preferences/shared_preferences.dart';


class ProgressStorage {
  static const _completedLevelsKey = 'completed_levels';

  Future<List<int>> getCompletedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_completedLevelsKey)
        ?.map(int.parse)
        .toList() ?? [];
  }

  Future<void> markLevelCompleted(int levelId) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = await getCompletedLevels();
    if (!completed.contains(levelId)) completed.add(levelId);
    await prefs.setStringList(
        _completedLevelsKey, completed.map((e) => e.toString()).toList());
  }
}


