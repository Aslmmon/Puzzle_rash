// lib/presentation/widgets/win_overlay.dart
import 'package:flutter/material.dart';

class WinOverlay extends StatefulWidget {
  final int moves;
  final int stars;
  final int coinsEarned;
  final VoidCallback? onNextLevel;
  final VoidCallback onChooseLevel;

  const WinOverlay({
    Key? key,
    required this.moves,
    required this.stars,
    required this.coinsEarned,
    this.onNextLevel,
    required this.onChooseLevel,
  }) : super(key: key);

  @override
  State<WinOverlay> createState() => _WinOverlayState();
}

class _WinOverlayState extends State<WinOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Level Complete!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Icon(
                      index < widget.stars ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Text('Moves: ${widget.moves}'),
                Text('Coins Earned: ${widget.coinsEarned}'),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.onNextLevel != null)
                      ElevatedButton(
                        onPressed: widget.onNextLevel,
                        child: const Text('Next Level'),
                      ),
                    if (widget.onNextLevel != null) const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: widget.onChooseLevel,
                      child: const Text('Choose Level'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
