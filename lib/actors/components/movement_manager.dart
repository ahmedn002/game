import 'package:flame/components.dart';

abstract class MovementManager {
  final double movementSpeed;
  late final Vector2 velocity;
  late final Vector2 storedVelocity;
  bool isFacingLeft;
  bool isInUninterruptibleAnimation;
  bool isInStoppingAnimation;
  final SpriteAnimationGroupComponent spriteAnimationComponent;

  MovementManager({
    required this.movementSpeed,
    this.isFacingLeft = false,
    this.isInUninterruptibleAnimation = false,
    this.isInStoppingAnimation = false,
    required this.spriteAnimationComponent,
  }) {
    storedVelocity = Vector2.zero();
    velocity = Vector2.zero();
  }

  void update(double dt);
}
