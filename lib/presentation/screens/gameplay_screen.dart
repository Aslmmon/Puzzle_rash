// lib/presentation/screens/gameplay_screen.dart
import 'package:flutter/material.dart';

class GameplayScreen extends StatelessWidget {
  final String levelId;

  const GameplayScreen({super.key, required this.levelId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gameplay - Level $levelId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Playing Level: $levelId',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement logic for completing the level
                // For now, just pop back
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Complete Level (Placeholder)'),
            ),
          ],
        ),
      ),
    );
  }
}
