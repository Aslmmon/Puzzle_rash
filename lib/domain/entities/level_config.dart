class LevelConfig {
  final int id;
  final int rows;
  final int cols;
  final String themeKey;

  const LevelConfig({
    required this.id,
    required this.rows,
    required this.cols,
    required this.themeKey,
  });

  /// Total number of cards in this level
  int get totalCards => rows * cols;

  /// Total number of pairs
  int get pairs => totalCards ~/ 2;
}
