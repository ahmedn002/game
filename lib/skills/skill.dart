import 'package:game/actors/actor.dart';

abstract class Skill {
  final String name;
  final String description;
  final SkillType type;
  final double coolDown; // in milliseconds
  bool isOnCoolDown;
  final bool isUninterruptibleAnimation;
  final bool isStoppingAnimation;
  final Actor actor;
  final ActorState actorState;

  Skill({
    required this.name,
    required this.description,
    required this.type,
    required this.coolDown,
    this.isOnCoolDown = false,
    required this.actor,
    this.actorState = ActorState.idle,
    required this.isUninterruptibleAnimation,
    required this.isStoppingAnimation,
  });

  // Should call execute when the skill is used
  // Handles the cooldown and the action of the skill
  void execute({final Actor? target}) {
    if (!isOnCoolDown) {
      action(target: target);
      isOnCoolDown = true;
      Future.delayed(Duration(microseconds: (coolDown * 1000).toInt()), () {
        isOnCoolDown = false;
      });
    }
  }

  // Should override action when implementing a new skill
  void action({final Actor? target});
}
