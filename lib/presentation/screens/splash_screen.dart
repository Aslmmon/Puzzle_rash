import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          builder:
              (context, value, child) => Opacity(opacity: value, child: child),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              FlutterLogo(size: 100),
              SizedBox(height: 20),
              Text(
                'Puzzle Rush',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
