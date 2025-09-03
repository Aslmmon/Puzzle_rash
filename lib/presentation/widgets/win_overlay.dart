import 'package:flutter/material.dart';

/// Shows a simple "You Won!" dialog
Future<void> showWinDialog({
  required BuildContext context,
  required int starsEarned,
  required int moves,
  required int coinsEarned,
  VoidCallback? onNextLevel,
  required VoidCallback onChooseLevel,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false, // force user to tap buttons
    builder: (context) {
      final screenWidth = MediaQuery.of(context).size.width;
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.green,
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🎉 You Won! 🎉',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Moves: $moves',
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Coins earned: $coinsEarned',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                    (i) => Icon(
                  i < starsEarned ? Icons.star : Icons.star_border,
                  color: Colors.yellowAccent,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          if (onNextLevel != null)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onNextLevel();
              },
              child: const Text('Next Level'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onChooseLevel();
            },
            child: const Text('Choose Level'),
          ),
        ],
      );
    },
  );
}
