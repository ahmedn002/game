import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/actors/actor.dart';
import 'package:game/main.dart';
import 'package:game/skills/types/attack.dart';

class DamagingHitbox extends PositionComponent with CollisionCallbacks {
  final Attack skill;
  final List<Actor> damagedActors = [];

  DamagingHitbox({
    required this.skill,
    required super.size,
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
      other.takeDamage(skill.calculateDamageWithModifiers());
      damagedActors.add(other);
      return;
    }
    super.onCollision(intersectionPoints, other);
  }
}
