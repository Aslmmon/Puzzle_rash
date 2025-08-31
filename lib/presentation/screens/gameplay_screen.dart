import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_controller.dart';
import '../widgets/memory_card_tile.dart';
import '../../domain/entities/level_config.dart';

class GameplayScreen extends ConsumerStatefulWidget {
  final LevelConfig level;

  const GameplayScreen({super.key, required this.level});

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      // Schedule startLevel after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(gameControllerProvider.notifier).startLevel(widget.level);
      });
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.level.id} - Moves: ${gameState.moves}'),
      ),
      body:
          gameState.deck.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.level.cols,
                ),
                itemCount: gameState.deck.length,
                itemBuilder: (context, index) {
                  final card = gameState.deck[index];
                  return MemoryCardTile(
                    card: card,
                    onTap:
                        () => ref
                            .read(gameControllerProvider.notifier)
                            .selectCard(index),
                  );
                },
              ),
      bottomSheet:
          gameState.won
              ? Container(
                color: Colors.green,
                height: 80,
                child: Center(
                  child: Text(
                    'You Won! 🎉 Moves: ${gameState.moves}',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              )
              : null,
    );
  }
}
