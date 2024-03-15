import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:my_game/game.dart';

class Player extends SpriteAnimationGroupComponent with HasGameRef<MyGame>, KeyboardHandler {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05; // Seconds

  final double movementSpeed = 100;
  Vector2 velocity = Vector2.zero();
  PlayerDirection direction = PlayerDirection.none;
  bool isFacingLeft = false;

  final String character;

  Player({this.character = 'Mask Dude'});

  @override
  FutureOr<void> onLoad() {
    _loadAnimations();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePosition(dt);
    _handleSpriteFlipByDirection();

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final bool leftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final bool rightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (leftKeyPressed && rightKeyPressed) {
      direction = PlayerDirection.none;
    } else if (leftKeyPressed) {
      direction = PlayerDirection.left;
    } else if (rightKeyPressed) {
      direction = PlayerDirection.right;
    } else {
      direction = PlayerDirection.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void _updatePosition(double dt) {
    double dx = 0;

    if (direction == PlayerDirection.none) {
      current = PlayerState.idle;
      return;
    }

    current = PlayerState.running;
    dx += (direction == PlayerDirection.left ? -1 : 1) * movementSpeed; // If left subtract, if right add

    velocity = Vector2(dx, 0.0);

    position += velocity * dt;
  }

  // Handle vertically flipping character model based on the current running direction
  void _handleSpriteFlipByDirection() {
    if (direction == PlayerDirection.left) {
      if (!isFacingLeft) {
        flipHorizontallyAroundCenter();
        isFacingLeft = true;
      }
    } else if (direction == PlayerDirection.right) {
      if (isFacingLeft) {
        flipHorizontallyAroundCenter();
        isFacingLeft = false;
      }
    }
  }

  void _loadAnimations() {
    idleAnimation = _spriteAnimation(state: 'Idle', amount: 11);
    runningAnimation = _spriteAnimation(state: 'Run', amount: 12);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    current = PlayerState.running;
  }

  SpriteAnimation _spriteAnimation({required final String state, required final int amount}) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/texture.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .25,
        textureSize: Vector2.all(32),
      ),
    );
  }
}

enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }
