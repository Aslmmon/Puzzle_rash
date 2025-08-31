import 'package:flutter/material.dart';
import '../../data/cache/progress_storage.dart';
import 'main_menu_screen.dart'; // We'll create this in Day 3

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAppData();
  }

  Future<void> _initializeAppData() async {
    // Simulate loading tasks (e.g., Firebase, ads, assets)
    // Replace these with your actual async initialization logic
    await Future.delayed(const Duration(seconds: 1)); // Simulate Firebase init
    print("Firebase initialized (simulated)");

    await Future.delayed(const Duration(seconds: 1)); // Simulate Ads init
    print("Ads initialized (simulated)");

    await Future.delayed(
      const Duration(seconds: 1),
    ); // Simulate other assets loading
    print("Other assets loaded (simulated)");

    // After all tasks are complete, navigate to the main menu
    if (mounted) {
      // Check if the widget is still in the tree
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainMenuScreen(),
        ), // We'll create MainMenuScreen in Day 3
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
