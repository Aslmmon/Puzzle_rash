import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget menuButton(String text, String route) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
        child: ElevatedButton(
          onPressed: () => context.go(route),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: Text(text, style: const TextStyle(fontSize: 18)),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Rush - Main Menu'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            menuButton('Play', '/level-selection'),
            menuButton('Daily Puzzle', '/daily-puzzle'),
            menuButton('Shop', '/shop'),
            menuButton('Settings', '/settings'),
          ],
        ),
      ),
    );
  }
}
