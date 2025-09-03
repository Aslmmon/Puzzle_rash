// lib/presentation/widgets/level_button.dart
import 'package:flutter/material.dart';
import 'package:puzzle_rush/domain/entities/level_config.dart';

class LevelButton extends StatelessWidget {
  final LevelConfig level;
  final VoidCallback? onPressed;

  const LevelButton({super.key, required this.level, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final buttonColor =
        level.isLocked ? Colors.grey.shade400 : Theme.of(context).primaryColor;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Column(
        // <--- Changed from Stack to Column
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Locked icon and level number
          if (level.isLocked)
            const Icon(Icons.lock_outline, size: 40, color: Colors.white)
          else
            Text(
              level.id.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

          // Stars container (visible only when not locked)
          if (!level.isLocked) ...[
            const SizedBox(height: 8), // Add some space
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  Icons.star,
                  size: 20,
                  color: _getStarColor(index + 1, level.stars),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  // Get the color for the star based on the count
  Color _getStarColor(int starNumber, int earnedStars) {
    if (starNumber <= earnedStars) {
      if (earnedStars == 3) {
        return Colors.greenAccent;
      } else if (earnedStars == 2) {
        return Colors.green.shade600;
      } else {
        return Colors.red.shade400;
      }
    }
    return Colors.grey;
  }
}
