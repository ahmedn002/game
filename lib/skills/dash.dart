import 'dart:math';

import 'package:flame/components.dart';
import 'package:my_game/skills/skill.dart';
import 'package:my_game/utils/extensions/vector.dart';

class Dash extends Skill {
  final double range = 100.0;

  Dash({
    required super.actor,
  }) : super(name: 'Dash', description: 'Dash forward', coolDown: 1.0);

  @override
  void execute() {
    final double horizontalMovement = actor.velocity.horizontalFactor * range;
    final double verticalMovement = actor.velocity.verticalFactor * range;

    final Vector2 dashVector = Vector2(horizontalMovement, verticalMovement);

    final double factor = actor.velocity.isDiagonal ? 1 / sqrt2 : 1.0;

    actor.position.add(dashVector * factor);
  }
}
