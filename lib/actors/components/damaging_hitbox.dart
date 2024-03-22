import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/actors/actor.dart';
import 'package:game/main.dart';
import 'package:game/skills/types/attack.dart';

class DamagingHitbox extends PositionComponent with CollisionCallbacks {
  final Attack skill;
  final List<Actor> damagedActors = [];
  final Vector2 attackForceDirection;

  DamagingHitbox({
    required this.skill,
    required super.size,
    required this.attackForceDirection,
  });

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(isSolid: true));
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // if colliding object is an actor
    // and is not the actor that used the skill
    // and has not been damaged already by this skill (Because this gets called every update)
    if (other is Actor && other != skill.actor && !damagedActors.contains(other)) {
      logger.i('Damaging ${other.runtimeType}');
      final double damage = skill.calculateDamageWithModifiers();

      final Vector2 intersectionPointsSum = intersectionPoints.reduce((value, element) => value + element);
      final Vector2 intersectionPointsAverage = intersectionPointsSum / intersectionPoints.length.toDouble();
      final Vector2 exertedForceDirection = (other.position - intersectionPointsAverage).normalized();

      // Exerted Force: The force exerted by the skill on the contacted actor depending on the center of the hitbox and position of the actor
      // Attack Force: The original direction of the attack itself
      const double alpha = 0.7;
      final Vector2 averageForceDirection = (exertedForceDirection * alpha) + (attackForceDirection * (1 - alpha));

      final Vector2 force = averageForceDirection.normalized() * damage;

      other.takeDamage(damage, force);

      damagedActors.add(other);

      super.onCollision(intersectionPoints, other);
      return;
    }
    super.onCollision(intersectionPoints, other);
  }
}
