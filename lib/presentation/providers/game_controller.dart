import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/data/cache/progress_storage.dart';
import 'package:puzzle_rush/presentation/providers/theme_provider.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/memory_card.dart';
import '../../domain/entities/level_config.dart';
import '../../domain/usecases/generate_deck.dart';
import '../providers/storageProvider.dart';
import 'levels_provider.dart';

final gameControllerProvider = StateNotifierProvider<GameController, GameState>(
  (ref) => GameController(
    ref: ref,
    storage: ref.watch(progressStorageProvider),
    generateDeck: GenerateDeck(repository: ref.watch(themeRepositoryProvider)),
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
  }) : super(GameState(deck: [])) {
    _firstCard = null;
    _secondCard = null;
  }

  final matchedCardStream = StreamController<int>.broadcast();
  final winStream = StreamController<void>.broadcast();

  MemoryCard? _firstCard;
  MemoryCard? _secondCard;

  /// Start a level
  Future<void> startLevel(LevelConfig level) async {
    final coins = await storage.getCoins(); // load total coins
    state = state.copyWith(
      deck: generateDeck(level),
      moves: 0,
      won: false,
      currentLevel: level,
      totalCoins: coins,
    );
    _firstCard = null;
    _secondCard = null;
  }

  /// Select a card
  void selectCard(int index) {
    final card = state.deck[index];
    if (card.revealed || card.matched) return;

    final newDeck = List<MemoryCard>.from(state.deck);
    newDeck[index] = card.reveal();

    if (_firstCard == null) {
      _firstCard = newDeck[index];
      state = state.copyWith(deck: newDeck);
      return;
    }

    if (_secondCard == null) {
      _secondCard = newDeck[index];
      state = state.copyWith(deck: newDeck, moves: state.moves + 1);

      if (_firstCard!.pairId == _secondCard!.pairId) {
        // Match found
        final matchedDeck =
            newDeck.map((c) {
              if (c.pairId == _firstCard!.pairId) return c.match();
              return c;
            }).toList();

        state = state.copyWith(deck: matchedDeck);
        matchedCardStream.add(_firstCard!.pairId);

        _firstCard = null;
        _secondCard = null;

        if (matchedDeck.every((c) => c.matched)) {
          _handleWin();
        }
      } else {
        // Not matched: hide after 1s
        Future.delayed(const Duration(seconds: 1), () {
          final tempDeck =
              newDeck.map((c) => c.matched ? c : c.hide()).toList();
          state = state.copyWith(deck: tempDeck);
          _firstCard = null;
          _secondCard = null;
        });
      }
    }
  }

  /// Handle level win
  Future<void> _handleWin() async {
    final currentLevel = state.currentLevel;
    if (currentLevel == null) return;

    // Calculate stars based on moves
    final stars = calculateStars(state.moves, currentLevel.movesLimit);

    // Reward coins (e.g., 10 per star)
    final coinsEarned = stars * 10;

    // Save progress
    await storage.markLevelCompleted(currentLevel.id);
    await storage.saveStars(currentLevel.id, stars);
    await storage.addCoins(coinsEarned);

    // Unlock next level
    await ref.read(levelsProvider.notifier).markLevelCompleted(currentLevel.id);
    final updatedCoins = await storage.getCoins();

    state = state.copyWith(won: true, totalCoins: updatedCoins);
    winStream.add(null);
  }

  int calculateStars(int moves, int movesLimit) {
    if (moves <= movesLimit ~/ 2) {
      return 3; // excellent
    } else if (moves <= movesLimit) {
      return 2; // good
    } else {
      return 1; // minimum
    }
  }

  @override
  void dispose() {
    matchedCardStream.close();
    winStream.close();
    super.dispose();
  }
}
