import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/actors/components/health_bar.dart';
import 'package:game/actors/managers/movement_manager.dart';
import 'package:game/actors/managers/skill_manager.dart';
import 'package:game/actors/managers/sprite_loader.dart';

import 'components/damage_number.dart';

abstract class Actor extends SpriteAnimationGroupComponent with CollisionCallbacks {
  final String name;
  double _health;
  final double maxHealth;

  late final SpriteManager spriteManager;
  late final MovementManager movementManager;
  late final SkillManager skillManager;

  Actor({
    required this.name,
    required double health,
    required this.maxHealth,
  }) : _health = health;

  double get health => _health;
  set health(double value) {
    if (value > maxHealth) {
      _health = maxHealth;
    } else if (value < 0) {
      _health = 0;
    } else {
      _health = value;
    }
  }

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
        updateHealth: () => _health,
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
    priority = position.y.toInt(); // Z-index based on vertical position to fake depth
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

  void takeDamage(double damage, Vector2 force) {
    health -= damage;

    parent?.add(
      PositionComponent(
        position: position,
        children: [DamageNumber(damage)],
      ),
    );

    movementManager.addExponentiallyDecayingForce(force);
  }
}

enum ActorState { idle, running, attacking }

enum Direction { left, right, up, down, none }
