import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/presentation/providers/levels_provider.dart';
import '../providers/game_controller.dart';
import '../providers/soundServiceProvider.dart';
import '../widgets/memory_card_tile.dart';
import '../../domain/entities/level_config.dart';
import 'level_selection_screen.dart';

class GameplayScreen extends ConsumerStatefulWidget {
  final LevelConfig level;

  const GameplayScreen({super.key, required this.level});

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen>
    with TickerProviderStateMixin {
  bool _initialized = false;
  late final AnimationController _winController;
  late final Animation<double> _winScale;

  late final AnimationController _coinsController;
  Animation<int>? _coinsAnimation;

  int _coinsEarnedThisLevel = 0;
  int _totalCoins = 0;

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

    _coinsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final controller = ref.read(gameControllerProvider.notifier);
        controller.startLevel(widget.level);

        // Load total coins
        _totalCoins = await controller.storage.getCoins();
        setState(() {});

        // Listen to win event
        controller.winStream.stream.listen((_) async {
          _winController.forward();
          ref.read(soundServiceProvider).playWin();

          // Calculate stars & coins
          final stars = controller.calculateStars(
            ref.read(gameControllerProvider).moves,
            ref.read(gameControllerProvider).currentLevel!.movesLimit,
          );
          _coinsEarnedThisLevel = stars;

          // Animate coins earned
          _coinsAnimation = IntTween(
            begin: 0,
            end: _coinsEarnedThisLevel,
          ).animate(
            CurvedAnimation(parent: _coinsController, curve: Curves.easeOut),
          )..addListener(() {
            setState(() {});
          });

          _coinsController.forward(from: 0);

          // Update total coins after animation
          await Future.delayed(const Duration(milliseconds: 800));
          await controller.storage.addCoins(_coinsEarnedThisLevel);
          _totalCoins = await controller.storage.getCoins();
          _coinsEarnedThisLevel = 0;
          setState(() {});
        });
      });
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _winController.dispose();
    _coinsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final soundService = ref.read(soundServiceProvider);

    int starsEarned = 0;
    int coinsEarned = 0;
    if (gameState.currentLevel != null && gameState.won) {
      starsEarned = controller.calculateStars(
        gameState.moves,
        gameState.currentLevel!.movesLimit,
      );
      coinsEarned = starsEarned; // 1 coin per star for now
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Level ${widget.level.id} - Moves: ${gameState.moves}'),
            Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.yellowAccent),
                const SizedBox(width: 4),
                Text('${_totalCoins + (_coinsAnimation?.value ?? 0)}'),
              ],
            ),
          ],
        ),
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
                    matchedStream: controller.matchedCardStream.stream,
                    onTap: () {
                      controller.selectCard(index);
                      soundService.playTap();
                    },
                  );
                },
              ),
          // Win overlay
          if (gameState.won && gameState.currentLevel != null)
            Center(
              child: ScaleTransition(
                scale: _winScale,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.green,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '🎉 You Won! 🎉',
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Moves: ${gameState.moves}',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Coins earned: ${_coinsAnimation?.value ?? coinsEarned}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 3; i++)
                            Icon(
                              i < starsEarned ? Icons.star : Icons.star_border,
                              color: Colors.yellowAccent,
                              size: 32,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (gameState.currentLevel!.id <
                          ref.read(levelsProvider).length)
                        ElevatedButton(
                          onPressed: () {
                            final nextLevel =
                                ref.read(levelsProvider)[gameState
                                    .currentLevel!
                                    .id];
                            controller.startLevel(nextLevel);
                            _winController.reset();
                          },
                          child: const Text('Next Level'),
                        ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const LevelSelectionScreen(),
                            ),
                          );
                        },
                        child: const Text('Choose Level'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
