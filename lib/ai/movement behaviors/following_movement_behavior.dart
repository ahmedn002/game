import 'package:flame/components.dart';
import 'package:game/ai/movement%20behaviors/targeted_movement_behavior.dart';

class FollowingMovementBehavior extends TargetedMovementBehavior {
  FollowingMovementBehavior({
    required super.actor,
    required super.movementSpeed,
    required super.target,
  });

  @override
  Vector2 calculateDirection() {
    return getShortestPathDirection(target.position);
  }
}
