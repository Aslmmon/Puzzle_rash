// lib/domain/entities/game_state.dart
import 'package:puzzle_rush/domain/entities/memory_card.dart';
import 'package:puzzle_rush/domain/entities/level_config.dart';

class GameState {
  final List<MemoryCard> deck;
  final int moves;
  final bool isWin;
  final LevelConfig? currentLevel;
  final int totalCoins;

  const GameState({
    required this.deck,
    this.moves = 0,
    this.isWin = false,
    this.currentLevel,
    this.totalCoins = 0,
  });

  GameState copyWith({
    List<MemoryCard>? deck,
    int? moves,
    bool? isWin,
    LevelConfig? currentLevel,
    int? totalCoins,
  }) {
    return GameState(
      deck: deck ?? this.deck,
      moves: moves ?? this.moves,
      isWin: isWin ?? this.isWin,
      currentLevel: currentLevel ?? this.currentLevel,
      totalCoins: totalCoins ?? this.totalCoins,
    );
  }
}
