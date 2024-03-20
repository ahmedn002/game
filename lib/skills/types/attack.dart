import 'package:game/skills/types/skill.dart';

import '../../actors/actor.dart';
import 'enums.dart';

abstract class Attack extends Skill {
  final DamageType damageType;
  final double damage;

  Attack({
    required super.name,
    required super.description,
    required super.type,
    required super.coolDown,
    required super.isUninterruptibleAnimation,
    required super.isStoppingAnimation,
    required super.actor,
    super.actorState = ActorState.attacking,
    required this.damageType,
    required this.damage,
  });

  double calculateDamageWithModifiers() {
    return damage;
  }
}
