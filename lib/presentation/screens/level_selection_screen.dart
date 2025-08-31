import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/levels_provider.dart';
import '../widgets/level_config.dart';
import 'gameplay_screen.dart';
import '../../domain/entities/level_config.dart';

class LevelSelectionScreen extends ConsumerWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = ref.watch(levelsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Level')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1.0,
          ),
          itemCount: levels.length,
          itemBuilder: (context, index) {
            final LevelConfig level = levels[index];

            return LevelButton(
              level: level,
              onPressed: () {
                level.isLocked
                    ? null
                    : Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GameplayScreen(level: level),
                      ),
                    );
              },
            );
          },
        ),
      ),
    );
  }
}
