import 'level_config.dart';
import 'memory_card.dart';

class GameState {
  final List<MemoryCard> deck;
  final int moves;
  final bool won;
  final LevelConfig? currentLevel;
  final int totalCoins; // new field

  GameState({
    required this.deck,
    this.moves = 0,
    this.won = false,
    this.currentLevel,
    this.totalCoins = 0,
  });

  GameState copyWith({
    List<MemoryCard>? deck,
    int? moves,
    bool? won,
    LevelConfig? currentLevel,
    int? totalCoins,
  }) {
    return GameState(
      deck: deck ?? this.deck,
      moves: moves ?? this.moves,
      won: won ?? this.won,
      currentLevel: currentLevel ?? this.currentLevel,
      totalCoins: totalCoins ?? this.totalCoins,
    );
  }
}
