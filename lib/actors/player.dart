import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game/actors/actor.dart';
import 'package:game/actors/managers/movement_manager.dart';
import 'package:game/actors/managers/player_movement_manager.dart';
import 'package:game/actors/managers/skill_manager.dart';
import 'package:game/actors/managers/sprite_loader.dart';
import 'package:game/game.dart';
import 'package:game/skills/basic_attack.dart';
import 'package:game/skills/dash.dart';

class Player extends Actor with HasGameRef<MyGame>, KeyboardHandler {
  final String spritesPath = 'Heroes/Cloak';
  late final PlayerMovementManager playerMovementManager;

  Player() : super(name: 'Player', health: 100, maxHealth: 100);

  @override
  FutureOr<void> onLoad() {
    super.onLoad(); // Loads All managers now that we have the gameRef
    _loadMovementManagerKeyCallbacks();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    playerMovementManager.handleKeyEvent(event, keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  MovementManager loadMovementManager() {
    final MovementManager movementManager = PlayerMovementManager(movementSpeed: 100, actor: this);
    playerMovementManager = movementManager as PlayerMovementManager;
    return movementManager;
  }

  void _loadMovementManagerKeyCallbacks() {
    playerMovementManager.keyPressCallbacks = {
      LogicalKeyboardKey.space: super.skillManager.loadSkillIntoQueue<Dash>,
      LogicalKeyboardKey.keyQ: super.skillManager.loadSkillIntoQueue<BasicAttack>,
    };
  }

  @override
  SkillManager loadSkillManager() {
    return SkillManager(
      actor: this,
      movementManager: movementManager,
      equippedSkills: [
        BasicAttack(actor: this),
        Dash(actor: this),
      ],
    );
  }

  @override
  SpriteManager loadSpriteManager() {
    return SpriteManager(
      actor: this,
      idleAnimationData: Animation(
        frameCount: 2,
        frameDuration: .2,
        image: game.images.fromCache('$spritesPath/IDLE.png'),
        size: Vector2.all(32),
      ),
      runAnimationData: Animation(
        frameCount: 8,
        frameDuration: 0.1,
        image: game.images.fromCache('$spritesPath/RUN.png'),
        size: Vector2.all(32),
      ),
      attackAnimationData: Animation(
        frameCount: 8,
        frameDuration: 0.1,
        image: game.images.fromCache('$spritesPath/ATTACK.png'),
        size: Vector2.all(32),
      ),
    );
  }
}
