import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:my_game/actors/actor.dart';
import 'package:my_game/actors/components/player_movement_manager.dart';
import 'package:my_game/actors/components/skill_manager.dart';
import 'package:my_game/actors/components/sprite_loader.dart';
import 'package:my_game/game.dart';
import 'package:my_game/skills/attack.dart';
import 'package:my_game/skills/dash.dart';

class Player extends SpriteAnimationGroupComponent with HasGameRef<MyGame>, KeyboardHandler implements Actor {
  final String spritesPath = 'Characters/Main';
  late final SpriteManager spriteManager;
  late final PlayerMovementManager movementManager;
  late final SkillManager skillManager;

  Player() {
    _loadAnimations();
    _loadMovementManager();
    _loadSkillManager();
  }

  @override
  String get name => 'Player';
  @override
  double get health => 100;
  @override
  double get maxHealth => 100;
  @override
  Vector2 get velocity => movementManager.velocity;
  @override
  double get movementSpeed => movementManager.movementSpeed;

  @override
  void onSkillStart(SkillType skillType) {
    skillManager.onSkillStart(skillType);
  }

  @override
  void onSkillEnd(SkillType skillType) {
    skillManager.onSkillEnd(skillType);
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
    movementManager.handleKeyEvent(event, keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }

  void _loadMovementManager() {
    movementManager = PlayerMovementManager(
      movementSpeed: 100,
      spriteAnimationComponent: this,
      keyPressCallbacks: {
        LogicalKeyboardKey.space: skillManager.loadSkillIntoQueue<Dash>,
        LogicalKeyboardKey.keyQ: skillManager.loadSkillIntoQueue<Attack>,
      },
    );
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
        path: '$spritesPath/IDLE.png',
        frameCount: 3,
        frameDuration: .33,
        game: game,
      ),
      runAnimationData: Animation(
        path: '$spritesPath/WALK.png',
        frameCount: 8,
        frameDuration: 0.1,
        game: game,
      ),
      attackAnimationData: Animation(
        path: '$spritesPath/ATTACK.png',
        frameCount: 7,
        frameDuration: 0.1,
        game: game,
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
