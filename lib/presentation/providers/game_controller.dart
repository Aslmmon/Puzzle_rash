// lib/presentation/providers/game_controller.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/data/cache/progress_storage.dart';
import 'package:puzzle_rush/domain/entities/game_state.dart';
import 'package:puzzle_rush/domain/entities/memory_card.dart';
import 'package:puzzle_rush/domain/entities/level_config.dart';
import 'package:puzzle_rush/domain/usecases/generate_deck.dart';
import 'levels_provider.dart';
import 'storageProvider.dart';
import 'theme_provider.dart';

final generateDeckProvider = Provider<GenerateDeck>((ref) {
  return GenerateDeck(repository: ref.watch(themeRepositoryProvider));
});

final gameControllerProvider = StateNotifierProvider.family<GameController, GameState, LevelConfig>(
      (ref, level) => GameController(
    ref: ref,
    storage: ref.watch(progressStorageProvider),
    generateDeck: ref.watch(generateDeckProvider),
    level: level,
  ),
);

class GameController extends StateNotifier<GameState> {
  final Ref ref;
  final ProgressStorage storage;
  final GenerateDeck generateDeck;

  GameController({
    required this.ref,
    required this.storage,
    required this.generateDeck,
    required LevelConfig level,
  }) : super(GameState(deck: [])) {
    _startLevel(level);
  }

  MemoryCard? _firstCard;
  MemoryCard? _secondCard;

  // Now an internal method called from the constructor
  Future<void> _startLevel(LevelConfig level) async {
    final coins = await storage.getCoins();
    state = GameState(
      deck: generateDeck(level),
      currentLevel: level,
      totalCoins: coins,
    );
  }

  void selectCard(int index) {
    if (state.isWin || (state.deck.where((c) => c.revealed && !c.matched).length >= 2)) {
      return;
    }

    final card = state.deck[index];
    if (card.revealed || card.matched) return;

    final newDeck = List<MemoryCard>.from(state.deck);
    newDeck[index] = card.reveal();

    // Check if it's the first card
    if (_firstCard == null) {
      _firstCard = newDeck[index];
      state = state.copyWith(deck: newDeck);
      return;
    }

    // It's the second card
    _secondCard = newDeck[index];
    final currentMoves = state.moves + 1;
    state = state.copyWith(deck: newDeck, moves: currentMoves);

    // Check for a match
    if (_firstCard!.pairId == _secondCard!.pairId) {
      final matchedDeck = newDeck.map((c) {
        if (c.pairId == _firstCard!.pairId) return c.match();
        return c;
      }).toList();
      state = state.copyWith(deck: matchedDeck);
      _firstCard = null;
      _secondCard = null;

      if (matchedDeck.every((c) => c.matched)) {
        _handleWin();
      }
    } else {
      // No match: flip cards back after a delay
      Future.delayed(const Duration(milliseconds: 700), () {
        final resetDeck = newDeck.map((c) => c.matched ? c : c.hide()).toList();
        state = state.copyWith(deck: resetDeck);
        _firstCard = null;
        _secondCard = null;
      });
    }
  }

  Future<void> _handleWin() async {
    final currentLevel = state.currentLevel;
    if (currentLevel == null) return;

    final stars = calculateStars(state.moves, currentLevel.movesLimit);
    final coinsEarned = stars * 10;

    await storage.markLevelCompleted(currentLevel.id);
    await storage.saveStars(currentLevel.id, stars);
    await storage.addCoins(coinsEarned);
    await ref.read(levelsProvider.notifier).markLevelCompleted(currentLevel.id);
    final updatedCoins = await storage.getCoins();

    state = state.copyWith(isWin: true, totalCoins: updatedCoins);
  }

  int calculateStars(int moves, int movesLimit) {
    if (moves <= movesLimit ~/ 2) {
      return 3;
    } else if (moves <= movesLimit) {
      return 2;
    } else {
      return 1;
    }
  }

  void reset() {
    state = state.copyWith(
      deck: generateDeck(state.currentLevel!),
      moves: 0,
      isWin: false,
    );
  }
}