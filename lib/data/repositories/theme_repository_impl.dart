import 'package:puzzle_rush/domain/respositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  @override
  List<String> labelsForTheme(String themeKey, int neededPairs) {
    // Example: simple emoji/text for themes
    final Map<String, List<String>> themeMap = {
      'palestine': ['🇵🇸', '🕌', '🕋', '📿', '🟩', '🟥', '🟦', '🟨', '🕊️', '🤲', '⭐️', '☀️', '🌸', '🌳'],
      'islam': ['🕌', '📿', '🕋', '🕊️', '☪️', '📖', '🤲', '⭐️', '☀️', '🌸', '🌳', '🌙', '🕌', '🕋'],
      'animals': ['🐶', '🐱', '🐭', '🐹', '🐰', '🐻', '🐼', '🐨', '🐯', '🦁', '🐷', '🐸', '🙊', '🐥'],
      'fruits': ['🍎', '🍊', '🍋', '🍇', '🍉', '🍓', '🍒', '🍑', '🍍', '🍌', '🥝', '🥥', '🥑', '🥭'],
      'sports': ['⚽️', '🏀', '🏈', '⚾️', '🎾', '🏐', '🏉', '🎱', '🏓', '🏸', '🥊', '🥋', '🛹', '🎳'],
    };

    final labels = themeMap[themeKey] ?? [];

    if (labels.length < neededPairs) {
      throw Exception('Not enough labels for theme $themeKey');
    }

    return labels.take(neededPairs).toList();
  }
}
