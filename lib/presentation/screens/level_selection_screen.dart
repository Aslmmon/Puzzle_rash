import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_rush/presentation/widgets/level_config.dart';
import 'package:puzzle_rush/service/router/app_router.dart';
import '../../domain/entities/level_config.dart';
import '../providers/levels_provider.dart';

class LevelSelectionScreen extends ConsumerWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = ref.watch(levelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 600 ? 6 : 4;
          double childAspectRatio = 1.0;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final LevelConfig level = levels[index];
                return LevelButton(
                  level: level,
                  onPressed:
                      level.isLocked
                          ? null
                          : () {
                            context.go(
                              RoutePaths.gameplay.replaceAll(
                                ':levelId',
                                level.id.toString(),
                              ),
                            );
                          },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
