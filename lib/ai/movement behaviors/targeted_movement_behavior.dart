import 'package:flame/components.dart';

import 'movement_behavior.dart';

abstract class TargetedMovementBehavior extends MovementBehavior {
  final PositionComponent target;

  TargetedMovementBehavior({
    required super.actor,
    required super.movementSpeed,
    required this.target,
  });

  Vector2 getShortestPathDirection(Vector2 targetPosition) {
    final double dx = targetPosition.x - actor.position.x;
    final double dy = targetPosition.y - actor.position.y;

    final Vector2 directionalityVector = Vector2(dx, dy).normalized();

    return directionalityVector;
  }
}
