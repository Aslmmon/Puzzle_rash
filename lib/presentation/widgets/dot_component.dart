// lib/game/dot_component.dart
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart'; // For Paint and Color

class DotComponent extends PositionComponent {
  static const double defaultRadius = 15.0;
  final Paint _paint;
  final double radius;
  final Color originalColor;
  final Color connectedColor = Colors.green; // Color when connected
  bool isConnected = false; // Track connection state

  DotComponent({
    required Vector2 position,
    this.originalColor = Colors.blue,
    this.radius = defaultRadius,
  }) : _paint = Paint()..color = originalColor,
       super(
         position: position,
         size: Vector2.all(radius * 2),
         anchor: Anchor.center,
       );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _paint.color =
        isConnected
            ? connectedColor
            : originalColor; // Update color based on state
    canvas.drawCircle(Offset(radius, radius), radius, _paint);
  }

  // Method to call when this dot is connected
  void connect() {
    if (!isConnected) {
      isConnected = true;
      // Add a pulse effect
      add(
        ScaleEffect.to(
          Vector2.all(1.5), // Scale up to 150%
          EffectController(
            duration: 0.2, // Duration of scaling up
            alternate: true, // Scale back down
            repeatCount: 1, // Do it once (up and back down)
          ),
        ),
      );
    }
  }

  // Method to reset the dot's state
  void reset() {
    isConnected = false;
  }
}
