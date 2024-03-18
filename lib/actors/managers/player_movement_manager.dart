import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game/actors/managers/movement_manager.dart';
import 'package:game/utils/settings/logs.dart';

import '../../main.dart';
import '../actor.dart';

class PlayerMovementManager extends MovementManager {
  late final Map<LogicalKeyboardKey, void Function()> keyPressCallbacks;
  Set<LogicalKeyboardKey> keysLastPressed = {};

  PlayerMovementManager({
    required super.movementSpeed,
    required super.actor,
  });

  @override
  void update(double dt) {
    _updatePosition(dt);
    super.update(dt);
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

    // If we are doing an activity which requires the character to stop, set the velocity to zero
    if (isInStoppingAnimation) {
      velocity.setZero();
    }

    actor.position += velocity.normalized() * movementSpeed * dt;
  }

  void handleKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final (Set<LogicalKeyboardKey> pressedKeys, Set<LogicalKeyboardKey> repeatedKeys) = _getPressedAndRepeatedKeysAndUpdateKeysHistory(keysPressed);

    if (LogSettings.shouldLogKeyPresses) {
      final List<String?> allKeysNames = keysPressed.map((key) => key.debugName).toList();
      final List<String?> pressedKeyNames = pressedKeys.map((key) => key.debugName).toList();
      final List<String?> repeatedKeyNames = repeatedKeys.map((key) => key.debugName).toList();
      final String formattedTime = DateTime.now().toString().split(' ').last;
      logger.f(
        'Event Type: ${event.runtimeType}\nAll Keys In Event: $allKeysNames\nKeys Pressed: $pressedKeyNames\nRepeated Keys: $repeatedKeyNames\nTime: $formattedTime',
      );
    }

    _handleHorizontalMovementKeyPress(keysPressed);
    _handleVerticalMovementKeyPress(keysPressed);
    if (event is KeyDownEvent) {
      _handleSkillsKeyPress(pressedKeys);
    }

    if (LogSettings.shouldLogMovement) {
      logger.d('Key event ended\nVelocity: $velocity\nStored velocity: $storedVelocity');
    }
  }

  (Set<LogicalKeyboardKey> pressedKeys, Set<LogicalKeyboardKey> repeatedKeys) _getPressedAndRepeatedKeysAndUpdateKeysHistory(Set<LogicalKeyboardKey> keysPressed) {
    final Set<LogicalKeyboardKey> repeatedKeys = keysLastPressed.intersection(keysPressed);
    final Set<LogicalKeyboardKey> pressedKeys = keysPressed.difference(repeatedKeys);
    keysLastPressed = keysPressed;
    return (pressedKeys, repeatedKeys);
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
      velocityToChange.y = -1;
    } else if (downKeyPressed) {
      velocityToChange.y = 1;
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
      velocityToChange.x = -1;
    } else if (rightKeyPressed) {
      velocityToChange.x = 1;
    } else {
      velocityToChange.x = 0;
    }
  }
}
