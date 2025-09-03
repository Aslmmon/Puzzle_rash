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
      body: Stack(
        children: [
          // This ensures the grid and other widgets are below the UI bar
          Column(
            children: [
              const SizedBox(height: 60), // Add space for the UI bar
              Expanded(child: CardsGrid(level: level)),
            ],
          ),
          // Your new custom UI bar at the top
          CustomGameplayUI(
            levelId: level.id.toString(),
            moves: gameState.moves,
            totalCoins: gameState.totalCoins,
            onRewardedAdTap: () {
              // TODO: Implement rewarded ad logic here
              print('Rewarded Ad button tapped!');
            },
          ),

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
                    nextLevel.id.toString()
                  ),
                );
              },
              onChooseLevel: () {
                resetGame();
                context.go(RoutePaths.levelSelection);
              },
            ),
        ],
      ),
    );
  }
}
