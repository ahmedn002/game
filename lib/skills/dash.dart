import 'dart:math';

import 'package:flame/components.dart';
import 'package:game/actors/actor.dart';
import 'package:game/skills/skill.dart';
import 'package:game/utils/extensions/vector.dart';

class Dash extends Skill {
  final double range = 600;
  final Duration duration = const Duration(milliseconds: 200);

  Dash({
    required super.actor,
  }) : super(
          name: 'Dash',
          description: 'Dash forward',
          type: SkillType.dash,
          coolDown: 2000,
          isUninterruptibleAnimation: true,
          isStoppingAnimation: false,
          actorState: ActorState.running,
        );

  @override
  void action({final Actor? target}) async {
    double horizontalMovement = actor.movementManager.velocity.horizontalFactor * range;
    if (actor.movementManager.velocity.isZero()) {
      horizontalMovement = actor.movementManager.isFacingLeft ? -range : range;
    }
    final double verticalMovement = actor.movementManager.velocity.verticalFactor * range;
    final Vector2 dashVector = Vector2(horizontalMovement, verticalMovement);

    final double factor = actor.movementManager.velocity.isDiagonal ? 1 / sqrt2 : 1.0;

    actor.skillManager.onSkillStart(
      skillType: type,
      isUninterruptibleAnimation: isUninterruptibleAnimation,
      isStoppingAnimation: isStoppingAnimation,
      actorState: actorState,
    );

    actor.movementManager.velocity.add(dashVector * factor);

    await Future.delayed(duration, () {
      actor.movementManager.velocity.sub(dashVector * factor);
    });

    actor.skillManager.onSkillEnd(
      skillType: type,
      wasUninterruptibleAnimation: isUninterruptibleAnimation,
      wasStoppingAnimation: isStoppingAnimation,
    );
  }
}
