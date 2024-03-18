import 'package:game/actors/actor.dart';
import 'package:game/skills/skill.dart';

class Attack extends Skill {
  Attack({
    required super.actor,
  }) : super(
          name: 'Attack',
          description: 'Attack the target',
          type: SkillType.attack,
          coolDown: 1000,
          isUninterruptibleAnimation: true,
          isStoppingAnimation: true,
          actorState: ActorState.attacking,
        );

  @override
  void action({final Actor? target}) async {
    actor.skillManager.onSkillStart(
      skillType: type,
      isUninterruptibleAnimation: isUninterruptibleAnimation,
      isStoppingAnimation: isStoppingAnimation,
      actorState: actorState,
    );

    await Future.delayed(const Duration(milliseconds: 700));

    actor.skillManager.onSkillEnd(
      skillType: type,
      wasUninterruptibleAnimation: isUninterruptibleAnimation,
      wasStoppingAnimation: isStoppingAnimation,
      wasDashInterrupted: actor.skillManager.currentSkillHasBeenDashInterrupted,
    );
  }
}
