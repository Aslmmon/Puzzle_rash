import 'package:flutter/material.dart';
import 'package:puzzle_rush/presentation/screens/level_selection_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Rush - Main Menu'),
        automaticallyImplyLeading:
            false, // Prevents back button to loading screen
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 8.0,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LevelSelectionScreen()),
                  );
                  print('Play button pressed');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Play', style: TextStyle(fontSize: 18)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 8.0,
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to Daily Puzzle screen
                  print('Daily Puzzle button pressed');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Daily Puzzle',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 8.0,
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to Shop screen
                  print('Shop button pressed');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Shop', style: TextStyle(fontSize: 18)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 8.0,
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to Settings screen
                  print('Settings button pressed');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Settings', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
