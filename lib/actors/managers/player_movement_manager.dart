import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game/actors/managers/movement_manager.dart';
import 'package:game/utils/extensions/vector.dart';

import '../actor.dart';

class PlayerMovementManager extends MovementManager {
  late final Map<LogicalKeyboardKey, void Function()> keyPressCallbacks;

  PlayerMovementManager({
    required super.movementSpeed,
    required super.actor,
  });

  @override
  void update(double dt) {
    _updatePosition(dt);
    _handleSpriteFlipByMovementDirection();
  }

  void _updatePosition(double dt) {
    // If no velocity and not in an uninterruptible animation
    if (velocity.isZero() && !isInUninterruptibleAnimation) {
      actor.current = ActorState.idle;
      return;
    }

    // If we are not doing something else, start running because there is velocity
    if (!isInUninterruptibleAnimation) {
      actor.current = ActorState.running;
    }

    // If Player is moving diagonally
    // Velocity vector speed becomes sqrt(movementSpeed^2 + movementSpeed^2) = sqrt(2 * movementSpeed^2)
    // To keep the same original movement speed we need to multiply by a factor
    // Solving for [ movementSpeed = sqrt(2 * movementSpeed^2) * x ]
    // x = 1 / sqrt(2)

    double factor = velocity.isDiagonal ? (1 / sqrt2) : 1;

    // If we are doing an activity which requires the character to stop, set the velocity to zero
    if (isInStoppingAnimation) {
      velocity.setZero();
    }

    actor.position += velocity * dt * factor;
  }

  void _handleSpriteFlipByMovementDirection() {
    if (velocity.x == 0) return;

    final bool isMovingRight = velocity.x > 0;

    if ((isFacingLeft && isMovingRight) || (!isFacingLeft && !isMovingRight)) {
      isFacingLeft = !isFacingLeft;
      actor.flipHorizontallyAroundCenter();
    }
  }

  void handleKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _handleHorizontalMovementKeyPress(keysPressed);
    _handleVerticalMovementKeyPress(keysPressed);
    _handleSkillsKeyPress(keysPressed);

    // logger.f(keysPressed);
    // logger.t('Player velocity in KeyEvent: $_velocity');
    // logger.i('Player stored velocity in KeyEvent: $_storedVelocity');
  }

  void _handleSkillsKeyPress(Set<LogicalKeyboardKey> keysPressed) {
    for (final key in keysPressed) {
      if (keyPressCallbacks.containsKey(key)) {
        keyPressCallbacks[key]!();
      }
    }
  }

  void _handleVerticalMovementKeyPress(Set<LogicalKeyboardKey> keysPressed) {
    final bool upKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) || keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final bool downKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) || keysPressed.contains(LogicalKeyboardKey.arrowDown);

    final Vector2 velocityToChange = isInUninterruptibleAnimation ? storedVelocity : velocity;

    if (upKeyPressed && downKeyPressed) {
      velocityToChange.y = 0;
    } else if (upKeyPressed) {
      velocityToChange.y = -movementSpeed;
    } else if (downKeyPressed) {
      velocityToChange.y = movementSpeed;
    } else {
      velocityToChange.y = 0;
    }
  }

  void _handleHorizontalMovementKeyPress(Set<LogicalKeyboardKey> keysPressed) {
    final bool leftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final bool rightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight);

    final Vector2 velocityToChange = isInUninterruptibleAnimation ? storedVelocity : velocity;

    if (leftKeyPressed && rightKeyPressed) {
      velocityToChange.x = 0;
    } else if (leftKeyPressed) {
      velocityToChange.x = -movementSpeed;
    } else if (rightKeyPressed) {
      velocityToChange.x = movementSpeed;
    } else {
      velocityToChange.x = 0;
    }
  }
}
