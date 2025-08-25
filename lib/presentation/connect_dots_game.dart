// lib/game/connect_dots_game.dart
import 'package:flame/components.dart'; // For Vector2
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_rush/presentation/widgets/dot_component.dart';

class ConnectDotsGame extends FlameGame with PanDetector {
  final String levelId;
  final List<Map<String, double>>? dotsData; // Receive parsed data

  final List<Vector2> _currentPathPoints = [];
  final Paint _linePaint =
      Paint()
        ..color =
            Colors
                .orangeAccent // Color of the line
        ..strokeWidth =
            10.0 // Thickness of the line
        ..style =
            PaintingStyle
                .stroke // Draw the line, don't fill
        ..strokeCap =
            StrokeCap
                .round // Rounded ends for the line
        ..strokeJoin = StrokeJoin.round; // Rounded joins for line segments

  final List<Vector2> _rawPathPoints = [];
  final List<Vector2> _connectedDotCenters = [];
  final List<DotComponent> _connectedDots = [];
  static const double snapDistanceThreshold = 30.0; // Adjust as needed
  static const double snapDistanceThresholdSquared =
      snapDistanceThreshold * snapDistanceThreshold;


  ValueNotifier<bool> levelSolvedNotifier = ValueNotifier<bool>(false); // To notify Flutter side

  ConnectDotsGame({required this.levelId, this.dotsData});

  @override
  Color backgroundColor() {
    return const Color(0xFFFAFAFA);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    print("ConnectDotsGame onLoad for level: $levelId. Dots data: $dotsData");
    _loadDots();
  }

  void _loadDots() {
    if (dotsData == null || dotsData!.isEmpty) {
      print("No dots data found for level $levelId");
      return;
    }

    for (final dotMap in dotsData!) {
      if (dotMap['x'] != null && dotMap['y'] != null) {
        final position = Vector2(dotMap['x']!, dotMap['y']!);
        add(DotComponent(position: position));
      }
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    super.onPanStart(info);
    _rawPathPoints.clear();
    _connectedDotCenters.clear();
    _connectedDots.forEach((dot) => dot.reset()); // Reset all dots
    _connectedDots.clear();
    final gamePoint = info.eventPosition.widget;
    _rawPathPoints.add(gamePoint);
    _tryConnectToDot(gamePoint); //
    _currentPathPoints.clear(); // Start a new path
    _currentPathPoints.add(info.eventPosition.widget); // Add the first point
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    final gamePoint = info.eventPosition.widget;
    _rawPathPoints.add(gamePoint);
    _tryConnectToDot(gamePoint);
    _currentPathPoints.add(
      info.eventPosition.widget,
    ); // Add current point to path
  }

  void _tryConnectToDot(Vector2 touchPoint) {
    // Iterate over all DotComponent children
    for (final component in children.whereType<DotComponent>()) {
      if (!component.isConnected) {
        // Only try to connect to unconnected dots
        // Calculate distance squared from touchPoint to dot's center
        final distanceSquared = component.position.distanceToSquared(
          touchPoint,
        );

        if (distanceSquared < snapDistanceThresholdSquared) {
          component.connect(); // Mark dot as connected
          _connectedDots.add(component);
          _connectedDotCenters.add(
            component.position.clone(),
          ); // Add its center to logical path

          // Optional: Snap the raw path's last point to the dot center for cleaner visual
          if (_rawPathPoints.isNotEmpty) {
            _rawPathPoints.last = component.position.clone();
          }
          break; // Connect to only one dot per update check for simplicity
        }
      }
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    super.onPanEnd(info);
    print("Path ended. Connected dots count: ${_connectedDots.length}");

    // --- Win Condition Check ---
    final totalDotsInLevel = children.whereType<DotComponent>().length;
    bool allDotsConnected = _connectedDots.length == totalDotsInLevel && totalDotsInLevel > 0;

    // Optional: Simple self-intersection check (basic version)
    // More robust self-intersection is complex. This is a naive check for simplicity.
    // bool pathIsSelfIntersecting = _checkSelfIntersection(_connectedDotCenters);

    if (allDotsConnected /* && !pathIsSelfIntersecting */) {
      print("Level Solved!");
      levelSolvedNotifier.value = true; // Notify listeners (Flutter UI)
      // Optional: Add a short delay or animation before this notification
      // to allow player to see the completed path.

      // You might want to prevent further interaction after solving
      // For now, the notifier handles telling the UI, which will likely navigate away or show a dialog.
    } else {
      print("Level not solved. Connected: ${_connectedDots.length}, Total: $totalDotsInLevel");
      // Optionally, you could provide feedback like resetting the path if it's invalid,
      // or just wait for the player to start a new path (which onPanStart handles by resetting).
      levelSolvedNotifier.value = false; // Ensure it's reset if a previous attempt was true
    }
  }

  bool _checkSelfIntersection(List<Vector2> path) {
    if (path.length < 4) return false; // Need at least 2 segments (4 points) to intersect

    for (int i = 0; i < path.length - 1; ++i) {
      final p1 = path[i];
      final p2 = path[i+1];
      for (int j = i + 2; j < path.length - 1; ++j) {
        // Avoid checking adjacent segments directly connected
        if (j == i+1) continue;

        final p3 = path[j];
        final p4 = path[j+1];

        if (_lineSegmentsIntersect(p1, p2, p3, p4)) {
          print("Path intersects!");
          return true;
        }
      }
    }
    return false;
  }

  // Helper for _checkSelfIntersection: Checks if segment p1-p2 intersects segment p3-p4
  // Based on an algorithm by Gavin Crabb
  bool _lineSegmentsIntersect(Vector2 p1, Vector2 p2, Vector2 p3, Vector2 p4) {
    double det(Vector2 a, Vector2 b) => a.x * b.y - a.y * b.x;
    Vector2 d1 = p2 - p1;
    Vector2 d2 = p4 - p3;
    Vector2 r = p1 - p3;
    double a = det(d1, d2);
    double b = det(r, d2);
    double c = det(r, d1);

    if (a == 0) { // Parallel or collinear
      // This basic check doesn't handle collinear overlapping segments perfectly.
      return false;
    }
    double t = b / a;
    double u = c / a;
    return t >= 0 && t <= 1 && u >= 0 && u <= 1;
  }


  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // If you need to re-center or adjust based on screen size, do it here.
    // For now, our coordinates are absolute.
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas); // Render dots

    // Draw the line based on _connectedDotCenters if available, else _rawPathPoints
    final Path pathToDraw = Path();
    List<Vector2> pointsToUse =
        _connectedDotCenters.isNotEmpty ? _connectedDotCenters : _rawPathPoints;

    if (pointsToUse.length > 1) {
      pathToDraw.moveTo(pointsToUse.first.x, pointsToUse.first.y);
      for (int i = 1; i < pointsToUse.length; i++) {
        pathToDraw.lineTo(pointsToUse[i].x, pointsToUse[i].y);
      }
      // If raw path has more points and we have some connected dots, draw segment to current touch
      if (_connectedDotCenters.isNotEmpty &&
          _rawPathPoints.isNotEmpty &&
          _rawPathPoints.last != _connectedDotCenters.last) {
        pathToDraw.lineTo(_rawPathPoints.last.x, _rawPathPoints.last.y);
      }
      canvas.drawPath(pathToDraw, _linePaint);
    } else if (_rawPathPoints.length == 1 && _connectedDotCenters.isEmpty) {
      // Draw a small circle at the start of a drag if no connections yet
      // canvas.drawCircle(Offset(_rawPathPoints.first.x, _rawPathPoints.first.y), _linePaint.strokeWidth / 2, _linePaint);
    }
  }

  @override
  void onRemove() { // Clean up the notifier
    levelSolvedNotifier.dispose();
    super.onRemove();
  }
}
