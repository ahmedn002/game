import 'package:game/skills/types/attack.dart';

abstract class AOEAttack extends Attack {
  final double range = 100;
  final double radius = 100;

  AOEAttack({
    required super.actor,
    required super.name,
    required super.description,
    required super.type,
    required super.coolDown,
    required super.isUninterruptibleAnimation,
    required super.isStoppingAnimation,
    required super.actorState,
    required super.damageType,
    required super.damage,
  });
}
