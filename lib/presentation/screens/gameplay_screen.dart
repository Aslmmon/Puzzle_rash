import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_controller.dart';
import '../providers/soundServiceProvider.dart';
import '../widgets/memory_card_tile.dart';
import '../../domain/entities/level_config.dart';

class GameplayScreen extends ConsumerStatefulWidget {
  final LevelConfig level;

  const GameplayScreen({super.key, required this.level});

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen>
    with SingleTickerProviderStateMixin {
  bool _initialized = false;
  late final AnimationController _winController;
  late final Animation<double> _winScale;

  @override
  void initState() {
    super.initState();
    _winController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _winScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _winController, curve: Curves.elasticOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = ref.read(gameControllerProvider.notifier);
        controller.startLevel(widget.level);

        // Listen to win event to trigger animation and sound
        controller.winStream.stream.listen((_) {
          _winController.forward();
          ref.read(soundServiceProvider).playWin();
        });
      });
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _winController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    final soundService = ref.read(soundServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.level.id} - Moves: ${gameState.moves}'),
      ),
      body: Stack(
        children: [
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
                    matchedStream:
                        ref
                            .read(gameControllerProvider.notifier)
                            .matchedCardStream
                            .stream,
                    onTap: () {
                      ref
                          .read(gameControllerProvider.notifier)
                          .selectCard(index);
                      soundService.playTap();
                    },
                  );
                },
              ),
          // Win animation overlay
          if (gameState.won)
            Center(
              child: ScaleTransition(
                scale: _winScale,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.green,
                  child: Text(
                    '🎉 You Won! 🎉 Moves: ${gameState.moves}',
                    style: const TextStyle(fontSize: 36, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
