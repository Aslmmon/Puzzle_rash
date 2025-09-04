// lib/presentation/providers/shop_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/data/cache/progress_storage.dart';
import 'package:puzzle_rush/domain/entities/shop_item.dart';
import 'package:puzzle_rush/presentation/providers/storageProvider.dart';

// The provider that holds the list of items
final shopControllerProvider = StateNotifierProvider<ShopController, List<ShopItem>>((ref) {
  return ShopController(ref.read(progressStorageProvider));
});

class ShopController extends StateNotifier<List<ShopItem>> {
  final ProgressStorage storage;

  ShopController(this.storage) : super(_initialItems);

  static final List<ShopItem> _initialItems = [
    const ShopItem(
      id: 'reveal_all',
      name: 'Reveal All',
      description: 'Briefly reveals all cards for 5 seconds.',
      cost: 500,
      icon: Icons.lightbulb_outline,
    ),
    const ShopItem(
      id: 'extra_moves',
      name: 'Extra Moves',
      description: 'Awards 5 extra moves to complete the level.',
      cost: 300,
      icon: Icons.trending_up,
    ),
  ];

  Future<bool> buyItem(String itemId) async {
    final item = state.firstWhere((item) => item.id == itemId);
    final currentCoins = storage.getCoins();

    if (currentCoins >= item.cost) {
      // Deduct the coins
      await storage.addCoins(-item.cost);

      // TODO: Implement logic to grant the item (e.g., update player inventory)
      print('Successfully purchased ${item.name}!');

      return true;
    } else {
      print('Not enough coins to purchase ${item.name}.');
      // TODO: Show a user-friendly error message
      return false;
    }
  }
}