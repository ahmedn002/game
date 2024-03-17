import 'dart:async';

import 'package:flame/components.dart';
import 'package:game/actors/managers/movement_manager.dart';
import 'package:game/actors/managers/skill_manager.dart';
import 'package:game/actors/managers/sprite_loader.dart';

abstract class Actor extends SpriteAnimationGroupComponent {
  final String name;
  final double health;
  final double maxHealth;

  late final SpriteManager spriteManager;
  late final MovementManager movementManager;
  late final SkillManager skillManager;

  Actor({
    required this.name,
    required this.health,
    required this.maxHealth,
  }) {
    movementManager = loadMovementManager();
    skillManager = loadSkillManager();
  }

  @override
  FutureOr<void> onLoad() {
    spriteManager = loadSpriteManager();
    return super.onLoad();
  }

  SpriteManager loadSpriteManager();
  MovementManager loadMovementManager();
  SkillManager loadSkillManager();

  void setAnimationMap({required Map<ActorState, SpriteAnimation> animationMap, required ActorState initialState}) {
    animations = animationMap;
    current = initialState;
  }
}

enum ActorState { idle, running, attacking }

enum Direction { left, right, up, down, none }

enum SkillType {
  dash,
  attack,
  heal,
  buff,
  debuff,
}
