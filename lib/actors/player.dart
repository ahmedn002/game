import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:my_game/game.dart';

class Player extends SpriteAnimationGroupComponent with HasGameRef<MyGame>, KeyboardHandler {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05; // Seconds

  final double movementSpeed = 100;
  Vector2 velocity = Vector2.zero();
  PlayerDirection horizontalDirection = PlayerDirection.none;
  PlayerDirection verticalDirection = PlayerDirection.none;
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
    final bool upKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) || keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final bool downKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) || keysPressed.contains(LogicalKeyboardKey.arrowDown);

    if (leftKeyPressed && rightKeyPressed) {
      horizontalDirection = PlayerDirection.none;
    } else if (leftKeyPressed) {
      horizontalDirection = PlayerDirection.left;
    } else if (rightKeyPressed) {
      horizontalDirection = PlayerDirection.right;
    } else {
      horizontalDirection = PlayerDirection.none;
    }

    if (upKeyPressed && downKeyPressed) {
      verticalDirection = PlayerDirection.none;
    } else if (upKeyPressed) {
      verticalDirection = PlayerDirection.up;
    } else if (downKeyPressed) {
      verticalDirection = PlayerDirection.down;
    } else {
      verticalDirection = PlayerDirection.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void _updatePosition(double dt) {
    if (horizontalDirection == PlayerDirection.none && verticalDirection == PlayerDirection.none) {
      current = PlayerState.idle;
      return;
    }

    current = PlayerState.running;

    velocity = Vector2(_getHorizontalMovementComponent(), _getVerticalMovementComponent());
    final bool isMovingVerticallyAndHorizontally = horizontalDirection != PlayerDirection.none && verticalDirection != PlayerDirection.none;

    // If Player is moving diagonally
    // Velocity vector speed becomes sqrt(movementSpeed^2 + movementSpeed^2) = sqrt(2 * movementSpeed^2)
    // To keep the same original movement speed we need to multiply by a factor
    // Solving for [ movementSpeed = sqrt(2 * movementSpeed^2) * x ]
    // x = 1 / sqrt(2)

    if (isMovingVerticallyAndHorizontally) {
      velocity = velocity * (1 / sqrt2);
    }

    position += velocity * dt;
  }

  double _getHorizontalMovementComponent() {
    double dx = 0;
    if (horizontalDirection == PlayerDirection.none) {
      return dx;
    }
    return (horizontalDirection == PlayerDirection.left ? -1 : 1) * movementSpeed;
  }

  double _getVerticalMovementComponent() {
    double dy = 0;
    if (verticalDirection == PlayerDirection.none) {
      return dy;
    }
    return (verticalDirection == PlayerDirection.up ? -1 : 1) * movementSpeed;
  }

  // Handle vertically flipping character model based on the current running direction
  void _handleSpriteFlipByDirection() {
    if (horizontalDirection == PlayerDirection.left) {
      if (!isFacingLeft) {
        flipHorizontallyAroundCenter();
        isFacingLeft = true;
      }
    } else if (horizontalDirection == PlayerDirection.right) {
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

enum PlayerDirection { left, right, up, down, none }
