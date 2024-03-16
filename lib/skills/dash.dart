import 'dart:math';

import 'package:flame/components.dart';
import 'package:my_game/skills/skill.dart';
import 'package:my_game/utils/extensions/vector.dart';

class Dash extends Skill {
  final double range = 600;
  final Duration duration = const Duration(milliseconds: 200);

  Dash({
    required super.actor,
  }) : super(name: 'Dash', description: 'Dash forward', coolDown: 2000);

  @override
  void action() async {
    final double horizontalMovement = actor.velocity.horizontalFactor * range;
    final double verticalMovement = actor.velocity.verticalFactor * range;
    final Vector2 dashVector = Vector2(horizontalMovement, verticalMovement);

    final double factor = actor.velocity.isDiagonal ? 1 / sqrt2 : 1.0;

    actor.onDashStart();

    actor.velocity.add(dashVector * factor);

    await Future.delayed(duration, () {
      actor.velocity.sub(dashVector * factor);
    });

    actor.onDashEnd();
  }
}
