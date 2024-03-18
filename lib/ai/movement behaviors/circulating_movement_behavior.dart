import 'package:flame/components.dart';
import 'package:game/ai/movement%20behaviors/targeted_movement_behavior.dart';

class CirculatingMovementBehavior extends TargetedMovementBehavior {
  CirculatingMovementBehavior({
    required super.actor,
    required super.movementSpeed,
    required super.target,
  });

  @override
  Vector2 calculateVelocity() {
    final Vector2 shortestPathVelocity = getShortestPathVelocity(target.position);
    final Vector2 perpendicularVelocity = Vector2(-shortestPathVelocity.y, shortestPathVelocity.x);

    return perpendicularVelocity;
  }
}
