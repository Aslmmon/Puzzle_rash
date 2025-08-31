import 'package:flutter/material.dart';
import '../../domain/entities/level_config.dart';

class LevelButton extends StatelessWidget {
  final LevelConfig level;
  final VoidCallback onPressed;

  const LevelButton({super.key, required this.level, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isLocked = level.isLocked;

    return ElevatedButton(
      onPressed: isLocked ? null : onPressed, // disable if locked
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        backgroundColor: isLocked ? Colors.grey : Colors.blue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Level ${level.id}',
            style: TextStyle(
              fontSize: 16,
              color: isLocked ? Colors.black45 : Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          if (isLocked) const Icon(Icons.lock, size: 18, color: Colors.black45),
        ],
      ),
    );
  }
}
