// lib/presentation/widgets/main_menu_app_bar.dart
import 'package:codeleek_core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/presentation/providers/soundServiceProvider.dart';
import 'package:puzzle_rush/presentation/providers/storageProvider.dart';

import 'game_button.dart';

class MainMenuAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MainMenuAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the player's coins and sound state
    final totalCoins = ref.watch(
      progressStorageProvider.select((p) => p.getCoins()),
    );
    // final isSoundOn = ref.watch(
    //   soundServiceProvider.select((s) => s.isSoundOn),
    // );

    return AppBar(
      title: Text('Memory Game', style: CoreTypography.headline1),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        // Coins display
        Row(
          children: [
            const Icon(Icons.monetization_on, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              '$totalCoins',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
          ],
        ),
        // Settings and Sound buttons
        GameChicletButton(icon: Icons.settings, onPressed: () {}),
        GameChicletButton(icon: Icons.volume_off, onPressed: () {}),
      ],
    );
  }
}
