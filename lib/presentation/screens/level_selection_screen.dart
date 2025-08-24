// lib/presentation/screens/level_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/level.dart'; // Your Level model
import '../../data/providers/level_provider.dart';
import '../widgets/level_button.dart';
import 'gameplay_screen.dart'; // Your Level provider
// We will create LevelButton widget in the next task
// import '../widgets/level_button.dart';

class LevelSelectionScreen extends ConsumerWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Task 3: Use ref.watch to access the LevelProvider
    final List<Level> levels = ref.watch(levelProvider);

    if (levels.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Select Level')),
        body: const Center(child: Text('No levels available.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        // You might want a back button to the main menu
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // Task 4: Use a GridView.builder
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Adjust number of columns
            crossAxisSpacing: 8.0, // Spacing between columns
            mainAxisSpacing: 8.0, // Spacing between rows
            childAspectRatio: 1.0, // Aspect ratio of items (1.0 for square)
          ),
          itemCount: levels.length,
          itemBuilder: (BuildContext context, int index) {
            final level = levels[index];
            // Placeholder for the LevelButton widget we will create next
            // For now, let's just display the level ID
            return LevelButton(
              level: level,
              onPressed: () {
                // Navigation logic will be added in Day 3
                print(
                  'Tapped on level: ${level.id}. Locked: ${level.isLocked}',
                );
                if (!level.isLocked) {
                  // Example: Navigate to a placeholder gameplay screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GameplayScreen(levelId: level.id),
                    ),
                  );
                }
              },
            );
            // return LevelButton(level: level); // This will be used once LevelButton is created
          },
        ),
      ),
    );
  }
}
