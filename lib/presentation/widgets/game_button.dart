import 'package:chiclet/chiclet.dart';
import 'package:codeleek_core/theme/colors.dart';
import 'package:codeleek_core/theme/typography.dart';
import 'package:flutter/material.dart';

class GameChicletButton extends StatelessWidget {
  final String? text;
  final IconData? icon; // Accept an optional icon
  final VoidCallback? onPressed;
  final Color startColor;
  final Color endColor;

  const GameChicletButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.startColor = CoreColors.CoreGreen,
    this.endColor = Colors.blueAccent,
  }) : assert(text != null || icon != null, 'Either text or icon must be provided.');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChicletOutlinedAnimatedButton(
        borderWidth: 0.5,
        width: icon != null ? 50 : 150,
        borderColor: Colors.black,
        onPressed: onPressed,
        backgroundColor: startColor,
        foregroundColor: endColor,
        borderRadius: 50,
        child: icon != null
            ? Icon(icon, color: Colors.white) // Use an icon
            : Text(text!, style: CoreTypography.buttonText), // Use text
      ),
    );
  }
}