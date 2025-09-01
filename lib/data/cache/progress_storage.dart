import 'package:shared_preferences/shared_preferences.dart';

class ProgressStorage {
  static const _completedLevelsKey = 'completed_levels';
  static const _coinsKey = 'coins';
  static const _starsKey = 'stars'; // stores stars per level as map string

  /// ===========================
  /// LEVEL PROGRESS
  /// ===========================
  Future<List<int>> getCompletedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_completedLevelsKey)
        ?.map(int.parse)
        .toList() ??
        [];
  }

  Future<void> markLevelCompleted(int levelId) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = await getCompletedLevels();
    if (!completed.contains(levelId)) completed.add(levelId);
    await prefs.setStringList(
        _completedLevelsKey, completed.map((e) => e.toString()).toList());
  }

  /// ===========================
  /// COINS
  /// ===========================
  Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_coinsKey) ?? 0;
  }

  Future<void> addCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getCoins();
    await prefs.setInt(_coinsKey, current + amount);
  }

  Future<void> setCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_coinsKey, amount);
  }

  /// ===========================
  /// STARS (per level)
  /// ===========================
  Future<Map<int, int>> getStars() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_starsKey);
    if (raw == null) return {};
    final Map<int, int> starsMap = {};
    for (final entry in raw) {
      final parts = entry.split(':'); // "levelId:stars"
      if (parts.length == 2) {
        final id = int.tryParse(parts[0]);
        final stars = int.tryParse(parts[1]);
        if (id != null && stars != null) starsMap[id] = stars;
      }
    }
    return starsMap;
  }

  Future<void> saveStars(int levelId, int stars) async {
    final prefs = await SharedPreferences.getInstance();
    final starsMap = await getStars();

    // keep max stars (don’t downgrade if user replays worse)
    final current = starsMap[levelId] ?? 0;
    if (stars > current) starsMap[levelId] = stars;

    final raw = starsMap.entries.map((e) => "${e.key}:${e.value}").toList();
    await prefs.setStringList(_starsKey, raw);
  }
}
