import 'package:flutter/material.dart';
import '../../domain/entities/level_config.dart';

class LevelButton extends StatelessWidget {
  final LevelConfig level;
  final VoidCallback onPressed;

  const LevelButton({super.key, required this.level, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(8.0)),
      child: Text('Level ${level.id}'),
    );
  }
}
