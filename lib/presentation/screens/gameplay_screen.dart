import 'dart:ffi';

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
import 'level_selection_screen.dart';

class GameplayScreen extends ConsumerStatefulWidget {
  final LevelConfig level;

  const GameplayScreen({super.key, required this.level});

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen> {
  bool _initialized = false;
  int _coinsEarnedThisLevel = 0;
  int _totalCoins = 0;
  AnimationController? _coinsController;
  Animation<int>? _coinsAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(gameControllerProvider.notifier);
      controller.startLevel(widget.level);

      // Load total coins
      _totalCoins = await controller.storage.getCoins();

      // Listen to win events
      controller.winStream.stream.listen((_) async {
        ref.read(soundServiceProvider).playWin();

        final stars = controller.calculateStars(
          ref.read(gameControllerProvider).moves,
          ref.read(gameControllerProvider).currentLevel!.movesLimit,
        );
        _coinsEarnedThisLevel = stars;

        // Update coins in storage
        await controller.storage.addCoins(_coinsEarnedThisLevel);
        _totalCoins = await controller.storage.getCoins();

        // Show dialog
        showWinDialog(
          context: context,
          starsEarned: stars,
          moves: ref.read(gameControllerProvider).moves,
          coinsEarned: _coinsEarnedThisLevel,
          onNextLevel: ref.read(levelsProvider).length >
              ref.read(gameControllerProvider).currentLevel!.id
              ? () {
            final nextLevel = ref
                .read(levelsProvider)[
            ref.read(gameControllerProvider).currentLevel!.id];
            controller.startLevel(nextLevel);
          }
              : null,
          onChooseLevel: () {
            context.go(RoutePaths.levelSelection);
          },
        );
      });
    });

    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final soundService = ref.read(soundServiceProvider);

    return Scaffold(
      appBar: GameplayAppBar(
        levelId: widget.level.id.toString(),
        moves: gameState.moves,
        totalCoins: _totalCoins,
        coinsAnimating: _coinsAnimation?.value,
      ),
      body: CardsGrid(
        deck: gameState.deck,
        cols: widget.level.cols,
        matchedStream: controller.matchedCardStream.stream,
        onTap: (index) {
          controller.selectCard(index);
          soundService.playTap();
        },
      ),
    );
  }
}