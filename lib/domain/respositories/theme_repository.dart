abstract class ThemeRepository {
  /// Returns a list of labels/assets for the given theme.
  /// [themeKey] can be 'palestine', 'islam', etc.
  /// [neededPairs] is the number of unique pairs required for the level.
  List<String> labelsForTheme(String themeKey, int neededPairs);
}
