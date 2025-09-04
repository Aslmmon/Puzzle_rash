// lib/presentation/widgets/custom_gameplay_ui.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_rush/presentation/providers/rewarded_provider.dart';
import 'package:puzzle_rush/service/router/app_router.dart';

class CustomGameplayUI extends ConsumerWidget {
  final String levelId;
  final int moves;
  final int totalCoins;

  const CustomGameplayUI({
    super.key,
    required this.levelId,
    required this.moves,
    required this.totalCoins,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the ad controller to see if an ad is loaded
    final rewardedAd = ref.watch(rewardedAdControllerProvider);
    final adController = ref.read(rewardedAdControllerProvider.notifier);

    // Check if an ad is currently ready to be shown
    final isAdReady = rewardedAd != null;

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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Text('Moves: $moves', style: const TextStyle(fontSize: 18)),
            ],
          ),

          // Coins and Rewarded Ad Button
          Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.amber),
              const SizedBox(width: 4),
              Text('$totalCoins', style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 16),
              // Button to show the rewarded ad
              IconButton(
                icon: Icon(
                  Icons.video_collection,
                  color: isAdReady ? Colors.greenAccent : Colors.grey,
                ),
                onPressed:
                    isAdReady
                        ? () {
                          adController.showAd();
                        }
                        : null, // Disable the button if no ad is ready
                tooltip: 'Get 200 coins!',
              ),
              IconButton(
                icon: const Icon(Icons.store, color: Colors.greenAccent),
                onPressed: () {
                  context.push(RoutePaths.shop);
                },
                tooltip: 'Go to the Shop',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
