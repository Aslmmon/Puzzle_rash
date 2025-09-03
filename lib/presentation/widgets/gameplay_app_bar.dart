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

class CustomGameplayUI extends StatelessWidget {
  final String levelId;
  final int moves;
  final int totalCoins;
  final VoidCallback? onRewardedAdTap; // Placeholder for the rewarded ad callback

  const CustomGameplayUI({
    super.key,
    required this.levelId,
    required this.moves,
    required this.totalCoins,
    this.onRewardedAdTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Level ID and Moves
          Row(
            children: [
              const Icon(Icons.star, color: Colors.yellow),
              const SizedBox(width: 8),
              Text(
                'Level $levelId',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              Text(
                'Moves: $moves',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),

          // Coins and Rewarded Ad Button
          Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '$totalCoins',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 16),
              // Placeholder for the rewarded ad button
              IconButton(
                icon: const Icon(Icons.video_collection, color: Colors.white),
                onPressed: onRewardedAdTap,
                tooltip: 'Get a free flip!',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
