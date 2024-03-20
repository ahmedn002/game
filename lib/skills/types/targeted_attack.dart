import 'package:game/actors/actor.dart';
import 'package:game/skills/types/attack.dart';

import 'enums.dart';

abstract class TargetedAttack extends Attack {
  final double range = 100;

  TargetedAttack({
    required super.actor,
  }) : super(
          name: 'Targeted Attack',
          description: 'Attack a single enemy',
          type: SkillType.attack,
          coolDown: 2000,
          isUninterruptibleAnimation: true,
          isStoppingAnimation: false,
          damageType: DamageType.physical,
          damage: 10,
        );

  @override
  void action({Actor? target}) {}
}
