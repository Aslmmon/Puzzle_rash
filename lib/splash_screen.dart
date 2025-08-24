import 'package:flutter/material.dart';
import 'dart:async';

import 'loading_screen.dart'; // Required for Timer

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Task 5: Add a timer to automatically navigate
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        // Check if the widget is still in the tree
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoadingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Make the background transparent
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for your logo
            // Replace this with your actual logo widget
            FlutterLogo(size: 100), // Example: FlutterLogo
            const SizedBox(height: 20),
            const Text(
              'Puzzle Rush',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color:
                    Colors.white, // Assuming a dark background or image behind
              ),
            ),
          ],
        ),
      ),
    );
  }
}
