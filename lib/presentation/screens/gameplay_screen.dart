import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_rush/presentation/providers/levels_provider.dart';
import 'package:puzzle_rush/presentation/widgets/cards_grid.dart';
import 'package:puzzle_rush/presentation/widgets/gameplay_app_bar.dart';
import 'package:puzzle_rush/presentation/widgets/win_overlay.dart';
import 'package:puzzle_rush/service/router/app_router.dart';
import '../providers/game_controller.dart';
import '../providers/soundServiceProvider.dart';
import '../../domain/entities/level_config.dart';

class GameplayScreen extends ConsumerStatefulWidget {
  final LevelConfig level;

  const GameplayScreen({super.key, required this.level});

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen> {
  // int _coinsEarnedThisLevel = 0;
  // int _totalCoins = 0;
  late final GameController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = ref.read(gameControllerProvider.notifier);
    _startLevelAndListenWin();
  }

  /// Start the level and subscribe to win events
  void _startLevelAndListenWin() async {
    await _controller.startLevel(widget.level);
    // _totalCoins = await _controller.storage.getCoins();
    // setState(() {});
    // Listen to win events
    _controller.winStream.stream.listen((_) async {
      ref.read(soundServiceProvider).playWin();
      final stars = _controller.calculateStars(
        ref.read(gameControllerProvider).moves,
        ref.read(gameControllerProvider).currentLevel!.movesLimit,
      );
      // _coinsEarnedThisLevel = stars;

      // Update storage
      await _controller.storage.addCoins(stars);
      _controller.state.copyWith(
        totalCoins: await _controller.storage.getCoins(),
      );
      // Show the win dialog
      _showWinDialog(stars);
    });
  }

  void _showWinDialog(int stars) {
    showWinDialog(
      context: context,
      starsEarned: stars,
      moves: ref.read(gameControllerProvider).moves,
      coinsEarned: stars,
      onNextLevel:
          _hasNextLevel()
              ? () {
                final nextLevel =
                    ref.read(levelsProvider)[_controller
                        .state
                        .currentLevel!
                        .id];
                _controller.startLevel(nextLevel);
              }
              : null,
      onChooseLevel: () {
        context.go(RoutePaths.levelSelection);
      },
    );
  }

  bool _hasNextLevel() {
    return ref.read(levelsProvider).length > _controller.state.currentLevel!.id;
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    final soundService = ref.read(soundServiceProvider);

    return Scaffold(
      appBar: GameplayAppBar(
        levelId: widget.level.id.toString(),
        moves: gameState.moves,
        totalCoins: gameState.totalCoins,
      ),
      body: CardsGrid(
        deck: gameState.deck,
        cols: widget.level.cols,
        matchedStream: _controller.matchedCardStream.stream,
        onTap: (index) {
          _controller.selectCard(index);
          soundService.playTap();
        },
      ),
    );
  }
}
