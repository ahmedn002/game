import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/actors/components/health_bar.dart';
import 'package:game/actors/managers/movement_manager.dart';
import 'package:game/actors/managers/skill_manager.dart';
import 'package:game/actors/managers/sprite_loader.dart';

abstract class Actor extends SpriteAnimationGroupComponent with CollisionCallbacks {
  final String name;
  double health;
  final double maxHealth;

  late final SpriteManager spriteManager;
  late final MovementManager movementManager;
  late final SkillManager skillManager;

  Actor({
    required this.name,
    required this.health,
    required this.maxHealth,
  });

  @override
  FutureOr<void> onLoad() {
    constructManagers();
    setAnimationMap(
      animationMap: {
        ActorState.idle: spriteManager.idleAnimation,
        ActorState.running: spriteManager.runAnimation,
        ActorState.attacking: spriteManager.attackAnimation,
      },
      initialState: ActorState.idle,
    );
    anchor = Anchor.center;

    add(
      HealthBar(
        maxHealth: maxHealth,
        updateHealth: () => health,
        shouldFlip: () => isFlippedHorizontally,
        barSize: Vector2(size.x, 5),
      ),
    );

    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    movementManager.update(dt);
    skillManager.update(dt);
    super.update(dt);
  }

  SpriteManager loadSpriteManager();
  MovementManager loadMovementManager();
  SkillManager loadSkillManager();

  void setAnimationMap({required Map<ActorState, SpriteAnimation> animationMap, required ActorState initialState}) {
    animations = animationMap;
    current = initialState;
  }

  void constructManagers() {
    spriteManager = loadSpriteManager();
    movementManager = loadMovementManager();
    skillManager = loadSkillManager();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // logger.i('Collision detected with $other');
    super.onCollision(intersectionPoints, other);
  }

  void takeDamage(double damage) {
    health -= damage;
  }
}

enum ActorState { idle, running, attacking }

enum Direction { left, right, up, down, none }
