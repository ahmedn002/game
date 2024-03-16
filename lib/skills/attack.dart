import 'package:my_game/actors/actor.dart';
import 'package:my_game/skills/skill.dart';

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
    actor.onSkillStart(super.type);
    print('Attacking ${target}');
    await Future.delayed(const Duration(milliseconds: 700));
    actor.onSkillEnd(super.type);
  }
}
