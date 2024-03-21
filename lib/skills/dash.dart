import 'package:flame/components.dart';
import 'package:game/actors/actor.dart';
import 'package:game/skills/types/enums.dart';
import 'package:game/skills/types/skill.dart';
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
    int horizontalDirection = actor.movementManager.direction.horizontalFactor;

    if (actor.movementManager.direction.isZero()) {
      horizontalDirection = actor.movementManager.isFacingLeft ? -1 : 1;
    }

    final verticalDirection = actor.movementManager.direction.verticalFactor;

    actor.movementManager.direction.setValues(horizontalDirection.toDouble(), verticalDirection.toDouble());

    final double oldMovementSpeed = actor.movementManager.movementSpeed;
    actor.movementManager.movementSpeed = range;

    actor.skillManager.onSkillStart(
      skillType: type,
      isUninterruptibleAnimation: isUninterruptibleAnimation,
      isStoppingAnimation: isStoppingAnimation,
      actorState: actorState,
    );

    await Future.delayed(duration, () {
      actor.movementManager.direction.setZero();
      actor.movementManager.movementSpeed = oldMovementSpeed;
    });

    actor.skillManager.onSkillEnd(
      skillType: type,
      wasUninterruptibleAnimation: isUninterruptibleAnimation,
      wasStoppingAnimation: isStoppingAnimation,
    );
  }
}
