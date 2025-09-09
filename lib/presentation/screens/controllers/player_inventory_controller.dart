// lib/presentation/providers/player_inventory_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/data/cache/progress_storage.dart';
import 'package:puzzle_rush/presentation/providers/storageProvider.dart';

// The provider that will hold the player's inventory
final playerInventoryProvider =
    StateNotifierProvider<PlayerInventoryController, Map<String, int>>((ref) {
      return PlayerInventoryController(ref.read(progressStorageProvider));
    });

class PlayerInventoryController extends StateNotifier<Map<String, int>> {
  final ProgressStorage storage;

  PlayerInventoryController(this.storage) : super({});

  // This method will be called during app initialization
  Future<void> loadInventory() async {
    final inventory = storage.getInventory();
    state = inventory;
  }

  // This method is called from the ShopController after a purchase
  void addItem(String itemId) {
    // We update the state by creating a new Map
    state = {...state};
    state[itemId] = (state[itemId] ?? 0) + 1;
    storage.saveInventory(state); // Persist the change
  }

  // This method is called from the GameplayScreen when a player uses an item
  bool useItem(String itemId) {
    if ((state[itemId] ?? 0) > 0) {
      state = {...state};
      state[itemId] = state[itemId]! - 1;
      storage.saveInventory(state);
      return true;
    }
    return false;
  }
}
