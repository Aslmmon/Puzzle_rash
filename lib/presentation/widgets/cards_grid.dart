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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 20,
          childAspectRatio: 2,
        ),
        itemCount: gameState.deck.length,
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
