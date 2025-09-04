// lib/presentation/widgets/custom_gameplay_ui.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:puzzle_rush/domain/entities/level_config.dart';
import 'package:puzzle_rush/presentation/providers/game_controller.dart';
import 'package:puzzle_rush/presentation/providers/rewarded_provider.dart';
import 'package:puzzle_rush/presentation/screens/controllers/player_inventory_controller.dart';
import 'package:puzzle_rush/service/router/app_router.dart';

class CustomGameplayUI extends ConsumerWidget {
  final String levelId;
  final int moves;
  final int totalCoins;
  final LevelConfig level;

  const CustomGameplayUI({
    super.key,
    required this.levelId,
    required this.moves,
    required this.totalCoins,
    required this.level,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch rewarded ad controller
    final rewardedAd = ref.watch(rewardedAdControllerProvider);
    final adController = ref.read(rewardedAdControllerProvider.notifier);
    final isAdReady = rewardedAd != null;

    // Watch player inventory
    final playerInventory = ref.watch(
      playerInventoryProvider,
    ); // No need for a family provider here
    final inventoryController = ref.read(playerInventoryProvider.notifier);
    final hasRevealAll = (playerInventory['reveal_all'] ?? 0) > 0;
    final hasExtraMoves = (playerInventory['extra_moves'] ?? 0) > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Level and Moves
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

          // Right side: Coins and buttons
          Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.amber),
              const SizedBox(width: 4),
              Text('$totalCoins', style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 16),
              // Button for Rewarded Ad
              IconButton(
                icon: Icon(
                  Icons.video_collection,
                  color: isAdReady ? Colors.greenAccent : Colors.red,
                ),
                onPressed:
                    isAdReady
                        ? () {
                          adController.showAd();
                        }
                        : null,
                tooltip: 'Get 200 coins!',
              ),
              // Button for "Reveal All" power-up
              IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: hasRevealAll ? Colors.greenAccent : Colors.red,
                ),
                onPressed:
                    hasRevealAll
                        ? () {
                          // Use the item from inventory, then trigger the game effect
                          final success = inventoryController.useItem(
                            'reveal_all',
                          );
                          if (success) {
                            ref
                                .read(gameControllerProvider(level).notifier)
                                .activateRevealAll();
                          }
                        }
                        : null,
                tooltip: 'Reveal all cards',
              ),

              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: hasExtraMoves ? Colors.greenAccent : Colors.red,
                ),
                onPressed:
                    hasExtraMoves
                        ? () {
                          final success = inventoryController.useItem(
                            'extra_moves',
                          );
                          if (success) {
                            ref
                                .read(gameControllerProvider(level).notifier)
                                .addMoves(5); // Add 5 moves
                          }
                        }
                        : null,
                tooltip: 'Get extra moves',
              ),
              // Button for the Shop
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
