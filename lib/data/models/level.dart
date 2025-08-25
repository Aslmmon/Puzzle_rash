// lib/data/models/level.dart

class Level {
  final String id; // Unique identifier for the level
  final int stars; // Number of stars earned (e.g., 0, 1, 2, 3)
  final bool isLocked; // Whether the level is currently locked
  // You might add more properties later, like:
  // final String puzzleType; // e.g., 'connect_dots', 'unblock_path'
  // final dynamic puzzleData; // Data specific to the puzzle type
  // final int bestTime; // Player's best time for the level
  // final int bestMoves; // Player's best move count
  final List<Map<String, double>>? connectDotsData; // New field for connect dots
  Level({
    required this.id,
    this.stars = 0,
    this.isLocked = true,
    this.connectDotsData,
    // required this.puzzleType,
    // required this.puzzleData,
  });

  // Optional: Add a copyWith method for easier state updates if using immutable state
  Level copyWith({
    String? id,
    int? stars,
    bool? isLocked,
    List<Map<String, double>>? connectDotsData,
  }) {
    return Level(
      id: id ?? this.id,
      stars: stars ?? this.stars,
      isLocked: isLocked ?? this.isLocked,
      connectDotsData: connectDotsData ?? this.connectDotsData,

    );
  }

  // Optional: For debugging or logging
  @override
  String toString() {
    return 'Level(id: $id, stars: $stars, isLocked: $isLocked)';
  }

  // Optional: If you need to compare Level objects
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Level &&
        other.id == id &&
        other.stars == stars &&
        other.isLocked == isLocked;
  }

  @override
  int get hashCode => id.hashCode ^ stars.hashCode ^ isLocked.hashCode;
}
