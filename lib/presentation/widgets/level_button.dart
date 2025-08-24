// lib/presentation/widgets/level_button.dart

import 'package:flutter/material.dart';
import '../../data/models/level.dart'; // Your Level model

class LevelButton extends StatelessWidget {
  final Level level;
  final VoidCallback? onPressed; // Callback for when the button is pressed

  const LevelButton({super.key, required this.level, this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Attempt to extract a simple number for display
    String displayLevelNumber = level.id;
    try {
      // Example: if id is "pack1_lvl3", this tries to get "3"
      // Adjust this logic based on your actual level ID format
      var parts = level.id.split('_');
      if (parts.length > 1 && parts.last.startsWith('lvl')) {
        displayLevelNumber = parts.last.substring(3);
      } else {
        // Fallback for other formats or just use the last part
        displayLevelNumber = parts.last;
      }
    } catch (e) {
      // If parsing fails, just use the raw id or a placeholder
      print("Error parsing level id for display: ${level.id} - $e");
    }

    return SizedBox(
      width: 70, // Define a fixed width or let GridView handle it
      height: 70, // Define a fixed height or let GridView handle it
      child: ElevatedButton(
        onPressed: level.isLocked ? null : onPressed,
        // <-- Uses the onPressed callback        // Disable button if level is locked
        style: ElevatedButton.styleFrom(
          backgroundColor: level.isLocked ? Colors.grey[300] : Colors.blue,
          foregroundColor: level.isLocked ? Colors.grey[600] : Colors.white,
          padding: EdgeInsets.zero,
          // Remove default padding to control content precisely
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ).copyWith(
          elevation: MaterialStateProperty.all(level.isLocked ? 0 : 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display Level Number
            Text(
              displayLevelNumber,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: level.isLocked ? Colors.grey[700] : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            // Display Star Rating (example with 3 stars)
            if (!level.isLocked) // Only show stars if not locked
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(
                    index < level.stars ? Icons.star : Icons.star_border,
                    color:
                        index < level.stars
                            ? Colors.yellowAccent
                            : Colors.white.withOpacity(0.7),
                    size: 16,
                  );
                }),
              ),
            // Visual indicator for locked state (alternative to disabling)
            if (level.isLocked)
              Icon(Icons.lock_outline, color: Colors.grey[700], size: 20),
          ],
        ),
      ),
    );
  }
}
