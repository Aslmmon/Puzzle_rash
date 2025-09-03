// lib/presentation/widgets/cards_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/domain/entities/level_config.dart';
import 'package:puzzle_rush/presentation/providers/game_controller.dart';
import 'package:puzzle_rush/presentation/providers/soundServiceProvider.dart';
import 'memory_card_tile.dart';

class CardsGrid extends ConsumerWidget {
  final LevelConfig level;

  const CardsGrid({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider(level));
    final gameController = ref.read(gameControllerProvider(level).notifier);
    final soundService = ref.read(soundServiceProvider);

    if (gameState.deck.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Determine the number of cards and screen dimensions
    final totalCards = gameState.deck.length;
    final rows = level.rows;
    final cols = level.cols;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols, // Set columns based on the level config
          mainAxisSpacing: 16,
          crossAxisSpacing: 24,
          // Calculate aspect ratio to fit all cards
          childAspectRatio: (MediaQuery.of(context).size.width / cols) / (MediaQuery.of(context).size.height / rows * 0.7),
        ),
        itemCount: totalCards,
        itemBuilder: (context, index) {
          final card = gameState.deck[index];
          return MemoryCardTile(
            card: card,
            onTap: () {
              gameController.selectCard(index);
              soundService.playTap();
            },
          );
        },
      ),
    );
  }
}