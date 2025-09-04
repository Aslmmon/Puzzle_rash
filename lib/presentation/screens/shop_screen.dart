// lib/presentation/screens/shop_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_rush/presentation/providers/storageProvider.dart';

import 'controllers/shop_controller.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopItems = ref.watch(shopControllerProvider);
    final currentCoins = ref.watch(
      progressStorageProvider.select((p) => p.getCoins()),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: shopItems.length,
        itemBuilder: (context, index) {
          final item = shopItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Icon(item.icon, size: 40),
              title: Text(
                item.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(item.description),
              trailing: ElevatedButton(
                onPressed:
                    currentCoins >= item.cost
                        ? () async {
                          await ref
                              .read(shopControllerProvider.notifier)
                              .buyItem(item.id);
                          // The UI will update automatically here
                        }
                        : null, // Disable the button if the user has no coins
                child: Text('${item.cost} Coins'),
              ),
            ),
          );
        },
      ),
    );
  }
}
