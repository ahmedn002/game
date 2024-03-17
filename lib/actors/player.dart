import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game/actors/actor.dart';
import 'package:game/actors/components/player_movement_manager.dart';
import 'package:game/actors/components/skill_manager.dart';
import 'package:game/actors/components/sprite_loader.dart';
import 'package:game/game.dart';
import 'package:game/skills/attack.dart';
import 'package:game/skills/dash.dart';

class Player extends Actor with HasGameRef<MyGame>, KeyboardHandler {
  final String spritesPath = 'Characters/Main';
  late final PlayerMovementManager playerMovementManager;

  Player()
      : super(
          name: 'Player',
          health: 100,
          maxHealth: 100,
        ) {
    _loadMovementManager();
    _loadSkillManager();
    _loadMovementManagerKeyCallbacks();
  }

  @override
  FutureOr<void> onLoad() {
    _loadAnimations();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    movementManager.update(dt);
    skillManager.update(dt);

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    playerMovementManager.handleKeyEvent(event, keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }

  void _loadMovementManager() {
    movementManager = PlayerMovementManager(
      movementSpeed: 100,
      spriteAnimationComponent: this,
    );

    playerMovementManager = movementManager as PlayerMovementManager;
  }

  void _loadMovementManagerKeyCallbacks() {
    playerMovementManager.keyPressCallbacks = {
      LogicalKeyboardKey.space: super.skillManager.loadSkillIntoQueue<Dash>,
      LogicalKeyboardKey.keyQ: super.skillManager.loadSkillIntoQueue<Attack>,
    };
  }

  void _loadSkillManager() {
    skillManager = SkillManager(
      actor: this,
      movementManager: movementManager,
      equippedSkills: [
        Attack(actor: this),
        Dash(actor: this),
      ],
    );
  }

  void _loadAnimations() {
    spriteManager = SpriteManager(
      actor: this,
      idleAnimationData: Animation(
        frameCount: 3,
        frameDuration: .33,
        image: game.images.fromCache('$spritesPath/IDLE.png'),
      ),
      runAnimationData: Animation(
        frameCount: 8,
        frameDuration: 0.1,
        image: game.images.fromCache('$spritesPath/WALK.png'),
      ),
      attackAnimationData: Animation(
        frameCount: 7,
        frameDuration: 0.1,
        image: game.images.fromCache('$spritesPath/ATTACK.png'),
      ),
    );

    animations = {
      ActorState.idle: spriteManager.idleAnimation,
      ActorState.running: spriteManager.runAnimation,
      ActorState.attacking: spriteManager.attackAnimation,
    };

    current = ActorState.running;
  }
}

enum ActorState { idle, running, attacking }

enum Direction { left, right, up, down, none }
