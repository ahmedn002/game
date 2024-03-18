import 'package:flame/components.dart';
import 'package:game/actors/actor.dart';

abstract class MovementManager {
  final double movementSpeed;
  late final Vector2 velocity;
  late final Vector2 storedVelocity;
  bool isFacingLeft;
  bool isInUninterruptibleAnimation;
  bool isInStoppingAnimation;
  final Actor actor;

  MovementManager({
    required this.movementSpeed,
    this.isFacingLeft = false,
    this.isInUninterruptibleAnimation = false,
    this.isInStoppingAnimation = false,
    required this.actor,
  }) {
    storedVelocity = Vector2.zero();
    velocity = Vector2.zero();
  }

  void update(double dt) {
    _handleSpriteFlipByMovementDirection();
  }

  void _handleSpriteFlipByMovementDirection() {
    if (velocity.x == 0) return;

    final bool isFacingLeft = actor.isFlippedHorizontally;

    final bool isMovingRight = velocity.x > 0;

    if ((isFacingLeft && isMovingRight) || (!isFacingLeft && !isMovingRight)) {
      actor.flipHorizontallyAroundCenter();
    }
  }
}
