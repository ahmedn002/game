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
        );

  @override
  void action() async {
    actor.skillManager.onSkillStart(type);
    await Future.delayed(const Duration(milliseconds: 700));
    actor.skillManager.onSkillEnd(type);
  }
}
