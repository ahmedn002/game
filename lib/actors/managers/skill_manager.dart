import 'dart:collection';

import 'package:flame/components.dart';
import 'package:game/actors/actor.dart';
import 'package:game/actors/managers/movement_manager.dart';
import 'package:game/skills/skill.dart';

class SkillManager {
  final SpriteAnimationGroupComponent actor;
  final MovementManager movementManager;
  final List<Skill> equippedSkills;
  late final Queue<Skill> skillsQueue;

  SkillManager({
    required this.actor,
    required this.movementManager,
    required this.equippedSkills,
  }) {
    skillsQueue = Queue<Skill>();
  }

  void handleSkillsQueue() {
    if (skillsQueue.isNotEmpty) {
      final Skill skill = skillsQueue.removeFirst(); // Dequeue first skill
      skill.execute();
    }
  }

  void loadSkillIntoQueue<S>() {
    final Skill skill = equippedSkills.firstWhere((skill) => skill is S);
    skillsQueue.add(skill);
  }

  void onSkillStart(SkillType skillType) {
    movementManager.isInUninterruptibleAnimation = true;

    if (skillType == SkillType.dash) {
      movementManager.storedVelocity.setFrom(movementManager.velocity);
    }

    if (skillType == SkillType.attack) {
      movementManager.isInStoppingAnimation = true;
      actor.current = ActorState.attacking;
    }
  }

  void onSkillEnd(SkillType skillType) {
    movementManager.isInUninterruptibleAnimation = false;

    if (skillType == SkillType.dash) {
      movementManager.velocity.setFrom(movementManager.storedVelocity);
      movementManager.storedVelocity.setZero();
    }

    if (skillType == SkillType.attack) {
      movementManager.isInStoppingAnimation = false;
    }

    actor.current = ActorState.idle;
  }

  void update(double dt) {
    handleSkillsQueue();
  }
}
