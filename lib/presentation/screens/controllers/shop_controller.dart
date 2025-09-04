

// The provider that holds the list of items
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/domain/entities/shop_item.dart';

final shopControllerProvider = StateNotifierProvider<ShopController, List<ShopItem>>((ref) {
  return ShopController();
});

class ShopController extends StateNotifier<List<ShopItem>> {
  ShopController() : super(_initialItems);

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
}