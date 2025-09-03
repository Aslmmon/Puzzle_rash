class LevelConfig {
  final int id;
  final int rows;
  final int cols;
  final String themeKey;
  final bool isLocked; // 🔑 Add this
  final int stars; // <-- Add this field

  const LevelConfig({
    required this.id,
    required this.rows,
    required this.cols,
    required this.themeKey,
    this.isLocked = true, // default locked
    this.stars = 0, // <-- Set a default value
  });

  LevelConfig copyWith({
    bool? isLocked,
    int? stars, // <-- Add this to copyWith
  }) {
    return LevelConfig(
      id: id,
      rows: rows,
      cols: cols,
      themeKey: themeKey,
      isLocked: isLocked ?? this.isLocked,
      stars: stars ?? this.stars, // <-- Update stars
    );
  }

  /// Total number of cards in this level
  int get totalCards => rows * cols;

  /// Total number of pairs
  int get pairs => totalCards ~/ 2;

  int get movesLimit => pairs * 2;
}
