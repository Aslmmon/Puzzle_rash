// lib/presentation/screens/gameplay_screen.dart
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/level_provider.dart';
import '../../data/models/level.dart';
import '../connect_dots_game.dart';

// Change to ConsumerStatefulWidget
class GameplayScreen extends ConsumerStatefulWidget {
  final String levelId;

  const GameplayScreen({super.key, required this.levelId});

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen> {
  late final ConnectDotsGame _gameInstance;

  @override
  void initState() {
    super.initState();

    // Find the specific level data (can also be done in build if levelId can change)
    final List<Level> allLevels = ref.read(
      levelProvider,
    ); // Use ref.read in initState
    final Level currentLevel = allLevels.firstWhere(
      (level) => level.id == widget.levelId,
      orElse: () => Level(id: 'unknown', connectDotsData: []),
    );

    _gameInstance = ConnectDotsGame(
      levelId: widget.levelId,
      dotsData: currentLevel.connectDotsData,
    );

    // Listen to the notifier from the game instance
    _gameInstance.levelSolvedNotifier.addListener(_onLevelSolved);
  }

  void _onLevelSolved() {
    if (_gameInstance.levelSolvedNotifier.value == true) {
      if (mounted) {
        // Ensure widget is still in the tree
        // Call Riverpod provider to update level state
        ref
            .read(levelProvider.notifier)
            .completeLevel(widget.levelId, 3); // Assume 3 stars for now

        // Show a dialog or navigate away
        showDialog(
          context: context,
          barrierDismissible: false, // User must tap button
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Level Complete!'),
              content: Text(
                'You solved level ${widget.levelId} and earned 3 stars!',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Next Level / Menu'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss dialog
                    if (Navigator.canPop(context)) {
                      Navigator.of(
                        context,
                      ).pop(); // Go back from GameplayScreen
                    }
                    // Optionally, navigate to next level or level selection directly
                  },
                ),
              ],
            );
          },
        );
        // Reset the notifier in the game so it doesn't immediately re-trigger if dialog is dismissed some other way
        _gameInstance.levelSolvedNotifier.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Note: _gameInstance is already created in initState
    return Scaffold(
      appBar: AppBar(
        title: Text('Gameplay - Level ${widget.levelId}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: GameWidget(game: _gameInstance),
    );
  }

  @override
  void dispose() {
    // Clean up: remove the listener and potentially tell the game to clean up
    _gameInstance.levelSolvedNotifier.removeListener(_onLevelSolved);
    // _gameInstance.onRemove(); // Flame's GameWidget usually handles this
    super.dispose();
  }
}
