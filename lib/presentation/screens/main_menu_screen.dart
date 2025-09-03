import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_rush/service/router/app_router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  // Modified menuButton to accept dynamic vertical padding
  Widget menuButton(String text, Function? callback, double verticalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 40.0,
        vertical: verticalPadding,
      ),
      child: ElevatedButton(
        onPressed: () => callback!(), // <-- use build context
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: verticalPadding * 1.5),
        ),
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Make the screen landscape-friendly
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Rush - Main Menu'),
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate vertical padding proportional to available height
          final double verticalPadding = constraints.maxHeight * 0.02;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                menuButton(
                  'Play',
                  () => context.go(RoutePaths.levelSelection),
                  verticalPadding,
                ),
                menuButton('Daily Puzzle', () {}, verticalPadding),
                menuButton('Shop', () {}, verticalPadding),
                menuButton('Settings', () {}, verticalPadding),
              ],
            ),
          );
        },
      ),
    );
  }
}
