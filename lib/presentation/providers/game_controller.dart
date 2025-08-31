import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/presentation/providers/theme_provider.dart';
import '../../domain/entities/memory_card.dart';
import '../../domain/entities/level_config.dart';
import '../../domain/usecases/generate_deck.dart';

final gameControllerProvider = StateNotifierProvider<GameController, GameState>(
  (ref) {
    final repo = ref.watch(themeRepositoryProvider);
    return GameController(generateDeck: GenerateDeck(repository: repo));
  },
);

class GameState {
  final List<MemoryCard> deck;
  final int moves;
  final bool won;

  GameState({required this.deck, this.moves = 0, this.won = false});

  GameState copyWith({List<MemoryCard>? deck, int? moves, bool? won}) {
    return GameState(
      deck: deck ?? this.deck,
      moves: moves ?? this.moves,
      won: won ?? this.won,
    );
  }
}

class GameController extends StateNotifier<GameState> {
  final GenerateDeck generateDeck;

  final matchedCardStream = StreamController<int>.broadcast();
  final winStream = StreamController<void>.broadcast();

  MemoryCard? _firstCard;
  MemoryCard? _secondCard;

  GameController({required this.generateDeck}) : super(GameState(deck: []));

  void startLevel(LevelConfig level) {
    final deck = generateDeck(level);
    state = GameState(deck: deck, moves: 0, won: false);
    _firstCard = null;
    _secondCard = null;
  }

  void selectCard(int index) {
    final card = state.deck[index];
    if (card.revealed || card.matched) return; // Ignore already revealed

    List<MemoryCard> newDeck = List.from(state.deck);
    newDeck[index] = card.reveal();

    if (_firstCard == null) {
      _firstCard = newDeck[index];
      state = state.copyWith(deck: newDeck);
    } else if (_secondCard == null) {
      _secondCard = newDeck[index];
      state = state.copyWith(deck: newDeck, moves: state.moves + 1);

      // Check for match
      if (_firstCard!.pairId == _secondCard!.pairId) {
        newDeck =
            newDeck.map((c) {
              if (c.pairId == _firstCard!.pairId) return c.match();
              return c;
            }).toList();
        state = state.copyWith(deck: newDeck);
        matchedCardStream.add(_firstCard!.pairId); // 🔔 Notify UI

        _firstCard = null;
        _secondCard = null;

        // Check if won
        if (newDeck.every((c) => c.matched)) {
          state = state.copyWith(won: true);
          winStream.add(null); // 🔔 Notify UI
        }
      } else {
        // Flip back after delay
        Future.delayed(const Duration(seconds: 1), () {
          List<MemoryCard> tempDeck = List.from(state.deck);
          tempDeck =
              tempDeck.map((c) {
                if (!c.matched) return c.hide();
                return c;
              }).toList();
          state = state.copyWith(deck: tempDeck);
          _firstCard = null;
          _secondCard = null;
        });
      }
    }
  }

  @override
  void dispose() {
    matchedCardStream.close();
    winStream.close();
    super.dispose();
  }
}
