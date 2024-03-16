import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:my_game/actors/actor.dart';
import 'package:my_game/game.dart';
import 'package:my_game/main.dart';
import 'package:my_game/skills/dash.dart';
import 'package:my_game/skills/skill.dart';

class Player extends SpriteAnimationGroupComponent with HasGameRef<MyGame>, KeyboardHandler implements Actor {
  // Sprite parameters
  final String character;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05; // Seconds

  // Movement parameters
  final double _movementSpeed = 100;
  final Vector2 _velocity = Vector2.zero();
  bool isFacingLeft = false;

  // Skills
  final Queue<Skill> skillsQueue = Queue<Skill>(); // Skills currently in queue by the player

  Player({this.character = 'Mask Dude'});

  ///////////////////////////////////////////////////////////
  //////////////// --- Actor Interface --- //////////////////
  ///////////////////////////////////////////////////////////

  @override
  String get name => 'Player';

  @override
  double get health => 100;

  @override
  double get maxHealth => 100;

  @override
  Vector2 get velocity => _velocity;

  @override
  double get movementSpeed => _movementSpeed;

  ///////////////////////////////////////////////////////////
  //////////////// --- Player Game Loop --- /////////////////
  ///////////////////////////////////////////////////////////

  @override
  FutureOr<void> onLoad() {
    _loadAnimations();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePosition(dt);
    _handleSpriteFlipByMovementDirection();
    _handleSkillsQueue(dt);

    super.update(dt);
  }

  void _handleSkillsQueue(double dt) {
    if (skillsQueue.isNotEmpty) {
      final Skill skill = skillsQueue.removeFirst(); // Dequeue first skill
      skill.execute();
    }
  }

  ///////////////////////////////////////////////////////////
  //////////////// --- Movement Handling --- ////////////////
  ///////////////////////////////////////////////////////////

  void _updatePosition(double dt) {
    if (_velocity.x == 0 && _velocity.y == 0) {
      current = PlayerState.idle;
      return;
    }

    current = PlayerState.running;

    final bool isMovingDiagonally = _velocity.x != 0 && _velocity.y != 0;

    // If Player is moving diagonally
    // Velocity vector speed becomes sqrt(movementSpeed^2 + movementSpeed^2) = sqrt(2 * movementSpeed^2)
    // To keep the same original movement speed we need to multiply by a factor
    // Solving for [ movementSpeed = sqrt(2 * movementSpeed^2) * x ]
    // x = 1 / sqrt(2)

    double factor = isMovingDiagonally ? (1 / sqrt2) : 1;

    position += velocity * dt * factor;
  }

  // Handle vertically flipping character model based on the current running direction
  void _handleSpriteFlipByMovementDirection() {
    if (velocity.x == 0) return;

    final bool isMovingRight = _velocity.x > 0;

    if ((isFacingLeft && isMovingRight) || (!isFacingLeft && !isMovingRight)) {
      isFacingLeft = !isFacingLeft;
      flipHorizontallyAroundCenter();
    }
  }

  ///////////////////////////////////////////////////////////
  //////////////// --- KeyPress Handling --- ////////////////
  ///////////////////////////////////////////////////////////

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _handleHorizontalMovementKeyPress(keysPressed);
    _handleVerticalMovementKeyPress(keysPressed);
    _handleSkillsKeyPress(keysPressed);

    logger.i(keysPressed);
    logger.t('Player velocity in KeyEvent: $_velocity');

    return super.onKeyEvent(event, keysPressed);
  }

  void _handleSkillsKeyPress(Set<LogicalKeyboardKey> keysPressed) {
    final bool spaceKeyPressed = keysPressed.contains(LogicalKeyboardKey.space);

    if (spaceKeyPressed) {
      skillsQueue.add(Dash(actor: this));
    }

    // Logger().i(skillsQueue);
  }

  void _handleVerticalMovementKeyPress(Set<LogicalKeyboardKey> keysPressed) {
    final bool upKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) || keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final bool downKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) || keysPressed.contains(LogicalKeyboardKey.arrowDown);

    if (upKeyPressed && downKeyPressed) {
      _velocity.y = 0;
    } else if (upKeyPressed) {
      _velocity.y = -_movementSpeed;
    } else if (downKeyPressed) {
      _velocity.y = _movementSpeed;
    } else {
      _velocity.y = 0;
    }
  }

  void _handleHorizontalMovementKeyPress(Set<LogicalKeyboardKey> keysPressed) {
    final bool leftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final bool rightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (leftKeyPressed && rightKeyPressed) {
      _velocity.x = 0;
    } else if (leftKeyPressed) {
      _velocity.x = -_movementSpeed;
    } else if (rightKeyPressed) {
      _velocity.x = _movementSpeed;
    } else {
      _velocity.x = 0;
    }
  }

  ///////////////////////////////////////////////////////////
  //////////////// --- Animation Handling --- ///////////////
  ///////////////////////////////////////////////////////////

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

enum Direction { left, right, up, down, none }
