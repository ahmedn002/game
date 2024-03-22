import 'dart:math';

import 'package:flame/components.dart';
import 'package:game/actors/actor.dart';
import 'package:game/main.dart';

abstract class MovementManager {
  double movementSpeed;
  late final Vector2 direction;
  late final Vector2 storedDirection;
  late final Vector2 velocity;
  List<CalculatedVector2> externalForces = [];
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
    storedDirection = Vector2.zero();
    direction = Vector2.zero();
    velocity = Vector2.zero();
  }

  void update(double dt) {
    _handleSpriteFlipByMovementDirection();
    _handleExternalForces(dt);
  }

  void _handleSpriteFlipByMovementDirection() {
    if (direction.x == 0) return;

    final bool isFacingLeft = actor.isFlippedHorizontally;

    final bool isMovingRight = direction.x > 0;

    if ((isFacingLeft && isMovingRight) || (!isFacingLeft && !isMovingRight)) {
      actor.flipHorizontallyAroundCenter();
    }
  }

  void addExponentiallyDecayingForce(Vector2 force) {
    externalForces.add(
      CalculatedVector2((double time) {
        return force * exp(-time * 10);
      }),
    );
  }

  void _handleExternalForces(double dt) {
    if (externalForces.isEmpty) return;

    Vector2 totalForce = Vector2.zero();

    for (final CalculatedVector2 force in externalForces) {
      final Vector2 calculatedForce = force.getVector(dt);
      if (calculatedForce.length < 0.1) {
        force.kill();
        continue;
      }
      totalForce.setFrom(totalForce + calculatedForce);
    }

    logger.i('Total Force: $totalForce');

    for (int i = 0; i < externalForces.length; i++) {
      if (externalForces[i].killed) {
        externalForces.removeAt(i);
      }
    }

    velocity.setFrom(velocity + totalForce * 200);
  }
}

class CalculatedVector2 {
  final Vector2 Function(double) calculateVector;
  double time = 0;
  bool killed = false;

  CalculatedVector2(this.calculateVector);

  Vector2 getVector(double dt) {
    if (killed) return Vector2.zero();
    time += dt;
    return calculateVector(time);
  }

  void kill() {
    killed = true;
  }
}
