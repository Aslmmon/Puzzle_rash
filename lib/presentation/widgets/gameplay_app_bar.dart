import 'package:flutter/material.dart';

/// AppBar for GameplayScreen
class GameplayAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String levelId;
  final int moves;
  final int totalCoins;

  const GameplayAppBar({
    super.key,
    required this.levelId,
    required this.moves,
    required this.totalCoins,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Level $levelId - Moves: $moves'),
          Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.yellowAccent),
              const SizedBox(width: 4),
              Text('$totalCoins'),
            ],
          ),
        ],
      ),
    );
  }
}
