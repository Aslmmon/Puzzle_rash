// lib/game/connect_dots_game.dart
import 'package:flame/components.dart'; // For Vector2
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_rush/presentation/widgets/dot_component.dart';

class ConnectDotsGame extends FlameGame with PanDetector {
  final String levelId;
  final List<Map<String, double>>? dotsData; // Receive parsed data
  bool _isPathStarted = false; // New flag to track if a valid path has started
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
        ..strokeJoin = StrokeJoin.round
        ..isAntiAlias = true; // Rounded joins for line segments

  final List<Vector2> _rawPathPoints = [];
  final List<Vector2> _connectedDotCenters = [];
  final List<DotComponent> _connectedDots = [];
  static const double snapDistanceThreshold = 30.0; // Adjust as needed
  static const double snapDistanceThresholdSquared =
      snapDistanceThreshold * snapDistanceThreshold;
  static const double dotPassThroughThresholdFactor = 0.5; // Line can't pass closer than 50% of a dot's radius
  ValueNotifier<bool> levelSolvedNotifier = ValueNotifier<bool>(
    false,
  ); // To notify Flutter side

  ConnectDotsGame({required this.levelId, this.dotsData});

  static const String soundConnect =
      'connect.mp3'; // Make sure this matches your file
  static const String soundLevelComplete =
      'level_complete.mp3'; // Make sure this matches

  @override
  Color backgroundColor() {
    return const Color(0xFFFAFAFA);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    print("ConnectDotsGame onLoad for level: $levelId. Dots data: $dotsData");
    await FlameAudio.audioCache.loadAll([soundConnect, soundLevelComplete]);
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
    for (var dot in children.whereType<DotComponent>()) {
      // More direct way to iterate
      dot.reset();
    }
    _connectedDots.clear();
    _isPathStarted = false; // Reset path started flag

    final gamePoint = info.eventPosition.widget;
    DotComponent? startingDot = _getDotAtPoint(gamePoint);

    if (startingDot != null && !startingDot.isConnected) {
      // Only start if on a valid, unconnected dot
      _isPathStarted = true; // Mark that a valid path has begun
      _rawPathPoints.add(
        startingDot.position.clone(),
      ); // Start raw path at dot center
      startingDot.connect();
      FlameAudio.play(
        soundConnect,
        volume: 0.5,
      ); // Play connect sound// Connect the starting dot
      _connectedDots.add(startingDot);
      _connectedDotCenters.add(startingDot.position.clone());
      print("Path started on dot: ${startingDot.position}");
    } else {
      print("Pan start not on a valid dot.");
      // No path is started, _rawPathPoints remains empty or is not processed further
    }
    //   _rawPathPoints.add(gamePoint);
    //   _tryConnectToDot(gamePoint); //
    //   _currentPathPoints.clear(); // Start a new path
    //   _currentPathPoints.add(info.eventPosition.widget); // Add the first point
    // }
  }

  DotComponent? _getDotAtPoint(Vector2 point) {
    for (final component in children.whereType<DotComponent>()) {
      // Check distance from the point to the dot's center
      // Use a slightly larger radius for touch activation if desired, or just dot's radius
      final touchRadius =
          component.radius +
          (snapDistanceThreshold - component.radius) /
              2; // Make snapDistance a bit more generous
      if (component.position.distanceToSquared(point) <
          touchRadius * touchRadius) {
        return component;
      }
    }
    return null;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    if (!_isPathStarted) return; // Don't process if path hasn't validly started

    final gamePoint = info.eventPosition.widget;
    if (_rawPathPoints.isNotEmpty) {
      // Ensure path has at least one point
      _rawPathPoints.add(gamePoint); // Add current point to visual path
    }
    DotComponent? lastConnectedDot =
        _connectedDots.isNotEmpty ? _connectedDots.last : null;
    DotComponent? currentOverDot = _getDotAtPoint(gamePoint);

    if (currentOverDot != null && !currentOverDot.isConnected) {
      // Check if this dot can be connected (e.g., it's not trying to skip over dots - more complex logic for later)
      // For now, simple connection if over an unconnected dot
      // And if the path doesn't already contain it.
      if (!_connectedDots.contains(currentOverDot)) {
        // Snap raw path's current segment end to this dot's center
        if (_rawPathPoints.isNotEmpty) {
          _rawPathPoints.last = currentOverDot.position.clone();
        }

        currentOverDot.connect();
        FlameAudio.play(soundConnect, volume: 0.5); // Play connect sound
        _connectedDots.add(currentOverDot);
        _connectedDotCenters.add(currentOverDot.position.clone());

        // Visual snap for the next segment start
        if (_rawPathPoints.isNotEmpty) {
          _rawPathPoints.add(
            currentOverDot.position.clone(),
          ); // Add again so next segment starts from dot center
        }
      }
    }
    // _rawPathPoints.add(gamePoint);
    // _tryConnectToDot(gamePoint);
    // _currentPathPoints.add(
    //   info.eventPosition.widget,
    // ); // Add current point to path
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
    if (!_isPathStarted) return;

    print("Path ended. Connected dots count: ${_connectedDots.length}");

    // --- Path Validation ---
    bool pathIsSelfIntersecting = _checkSelfIntersection(_connectedDotCenters);
    bool pathAvoidsOtherDots = _checkPathAvoidsOtherDots(_connectedDotCenters, children.whereType<DotComponent>().toList());

    if (pathIsSelfIntersecting) {
      print("Path is self-intersecting! Attempt invalid.");
      // ... (reset logic as before) ...
      FlameAudio.play('error.mp3'); // Assuming you have an error sound
      _resetPathAttempt();
      _isPathStarted = false;
      return;
    }

    if (!pathAvoidsOtherDots) {
      print("Path passes too close to another dot! Attempt invalid.");
      FlameAudio.play('error.mp3'); // Error sound
      _resetPathAttempt();
      _isPathStarted = false;
      return;
    }

    // --- Win Condition Check ---
    final totalDotsInLevel = children.whereType<DotComponent>().length;
    bool allDotsConnected = _connectedDots.length == totalDotsInLevel && totalDotsInLevel > 0;

    if (allDotsConnected) {
      print("Level Solved!");
      FlameAudio.play(soundLevelComplete, volume: 0.7);
      levelSolvedNotifier.value = true;
    } else {
      print("Level not solved. Connected: ${_connectedDots.length}, Total: $totalDotsInLevel");
      // Optionally play a "try again" sound
      levelSolvedNotifier.value = false;
      // Reset if not solved, or let player modify? For now, we only reset on explicit errors or new pan start.
    }
    _isPathStarted = false; // Reset for next touch attempt or if puzzle not solved
  }

  void _resetPathAttempt() {
    _rawPathPoints.clear();
    _connectedDotCenters.clear();
    _connectedDots.forEach((dot) => dot.reset());
    _connectedDots.clear();
    levelSolvedNotifier.value = false; // Ensure not marked as solved
  }

  bool _checkPathAvoidsOtherDots(List<Vector2> pathSegments, List<DotComponent> allDots) {
    if (pathSegments.length < 2) return true; // Not enough segments to check

    for (int i = 0; i < pathSegments.length - 1; i++) {
      final p1 = pathSegments[i]; // Start of current segment
      final p2 = pathSegments[i + 1]; // End of current segment

      for (final dot in allDots) {
        // Skip if the dot is one of the endpoints of the current segment
        if (dot.position.distanceToSquared(p1) < 0.01 || dot.position.distanceToSquared(p2) < 0.01) {
          // Using a small epsilon for floating point comparison to dot centers
          continue;
        }

        double distSquared = _distancePointToSegmentSquared(dot.position, p1, p2);
        double threshold = dot.radius * dotPassThroughThresholdFactor;
        if (distSquared < threshold * threshold) {
          print("Segment $p1-$p2 passes too close to dot ${dot.position}");
          return false; // Found a segment passing too close to another dot
        }
      }
    }
    return true; // All segments avoid other dots
  }

  // Calculates the square of the shortest distance from point C to line segment AB
  double _distancePointToSegmentSquared(Vector2 c, Vector2 a, Vector2 b) {
    final Vector2 ab = b - a;
    final Vector2 ac = c - a;
    final double abLengthSquared = ab.length2;

    if (abLengthSquared == 0) return ac.length2; // A and B are the same point

    // Project C onto the line defined by A and B
    double t = ac.dot(ab) / abLengthSquared;

    if (t < 0.0) return ac.length2; // Projection is outside segment, closest to A
    if (t > 1.0) return (c - b).length2; // Projection is outside segment, closest to B

    // Projection is inside the segment
    final Vector2 projection = a + ab * t;
    return (c - projection).length2;
  }



  bool _checkSelfIntersection(List<Vector2> path) {
    if (path.length < 4)
      return false; // Need at least 2 segments (4 points) to intersect

    for (int i = 0; i < path.length - 1; ++i) {
      final p1 = path[i];
      final p2 = path[i + 1];
      for (int j = i + 2; j < path.length - 1; ++j) {
        // Avoid checking adjacent segments directly connected
        // The condition "j == i+1" is actually covered by "j = i + 2" loop start,
        // but explicitly ensuring segments are not immediately consecutive is key.
        // A -> B -> C: Segment A-B should not be checked against B-C.
        // The loop for 'j' starts at 'i + 2', so we compare segment (i, i+1)
        // with segments (i+2, i+3), (i+3, i+4), etc. This is correct.

        final p3 = path[j];
        final p4 = path[j + 1];

        if (_lineSegmentsIntersect(p1, p2, p3, p4)) {
          print("Path intersects! Segments: ($p1-$p2) and ($p3-$p4)");
          return true;
        }
      }
    }
    return false;
  }

  bool _lineSegmentsIntersect(Vector2 p1, Vector2 p2, Vector2 p3, Vector2 p4) {
    double det(Vector2 a, Vector2 b) => a.x * b.y - a.y * b.x;
    Vector2 d1 = p2 - p1;
    Vector2 d2 = p4 - p3;
    Vector2 r = p1 - p3;
    double a = det(d1, d2);
    double b = det(r, d2);
    double c = det(r, d1);

    if (a == 0) {
      // Parallel or collinear
      // This basic check doesn't handle collinear overlapping segments perfectly.
      // For example, if p1-p2 and p3-p4 are on the same line and overlap.
      // A more robust check for collinear segments would be needed here if critical.
      // For now, let's assume non-collinear intersection is the primary concern.
      // If they are collinear, they "intersect" if they overlap.
      // This requires checking if their bounding boxes on that line overlap.
      // For simplicity, current version returns false for parallel/collinear.
      return false;
    }
    double t = b / a;
    double u = c / a;
    // Intersection exists if 0 <= t <= 1 and 0 <= u <= 1
    // Adding a small epsilon for floating point comparisons might be useful
    // in some edge cases but can also cause issues.
    // For now, direct comparison.
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

    if (!_isPathStarted && _rawPathPoints.isEmpty)
      return; // Don't draw if nothing has started

    final Path pathToDraw = Path();
    List<Vector2> pointsToUse =
        _connectedDotCenters; // Primarily use connected dot centers

    if (pointsToUse.isNotEmpty) {
      pathToDraw.moveTo(pointsToUse.first.x, pointsToUse.first.y);
      for (int i = 1; i < pointsToUse.length; i++) {
        pathToDraw.lineTo(pointsToUse[i].x, pointsToUse[i].y);
      }
      // Draw the segment from the last connected dot to the current raw touch position
      if (_rawPathPoints.isNotEmpty &&
          _rawPathPoints.last != pointsToUse.last) {
        pathToDraw.lineTo(_rawPathPoints.last.x, _rawPathPoints.last.y);
      }
      canvas.drawPath(pathToDraw, _linePaint);
    } else if (_rawPathPoints.isNotEmpty && _isPathStarted) {
      // If path started but no dots connected yet (should be rare with new logic)
      // or if only one raw point exists for some reason.
      // This case might need refinement based on how _isPathStarted and _rawPathPoints are managed.
      // For now, if _isPathStarted is true and _connectedDotCenters is empty,
      // it implies the first touch was valid, but maybe no drag yet.
      // The current render logic for _connectedDotCenters might cover most visual needs.
    }
  }

  @override
  void onRemove() {
    // Clean up the notifier
    levelSolvedNotifier.dispose();
    super.onRemove();
  }
}
