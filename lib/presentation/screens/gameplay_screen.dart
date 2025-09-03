import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_rush/presentation/providers/levels_provider.dart';
import 'package:puzzle_rush/presentation/widgets/cards_grid.dart';
import 'package:puzzle_rush/presentation/widgets/gameplay_app_bar.dart';
import 'package:puzzle_rush/presentation/widgets/win_overlay.dart';
import 'package:puzzle_rush/presentation/providers/game_controller.dart';
import 'package:puzzle_rush/domain/entities/level_config.dart';
import 'package:puzzle_rush/service/router/app_router.dart';

class GameplayScreen extends ConsumerWidget {
  final LevelConfig level;

  const GameplayScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the game state from the family provider.
    final gameState = ref.watch(gameControllerProvider(level));
    final gameController = ref.read(gameControllerProvider(level).notifier);
    void resetGame() => gameController.reset();

    return Scaffold(
      appBar: GameplayAppBar(
        levelId: level.id.toString(),
        moves: gameState.moves,
        totalCoins: gameState.totalCoins,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          CardsGrid(level: level),
          if (gameState.isWin)
            WinOverlay(
              moves: gameState.moves,
              stars: gameController.calculateStars(
                gameState.moves,
                level.movesLimit,
              ),
              coinsEarned:
                  gameController.calculateStars(
                    gameState.moves,
                    level.movesLimit,
                  ) *
                  10,
              onNextLevel: () {
                resetGame();
                final nextLevel = ref.read(levelsProvider)[level.id];
                context.go(
                  RoutePaths.gameplay.replaceAll(
                    ':levelId',
                    nextLevel.id.toString(),
                  ),
                );
              },
              onChooseLevel: () {
                print(
                  "levels are " +
                      ref.read(levelsProvider.notifier).state.length.toString(),
                );

                print(
                  "levels are " +
                      ref.read(levelsProvider.notifier).state.length.toString(),
                );

                resetGame();
                context.go(RoutePaths.levelSelection);
              },
            ),
        ],
      ),
    );
  }
}
