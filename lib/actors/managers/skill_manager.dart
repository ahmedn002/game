import 'dart:collection';

import 'package:flame/components.dart';
import 'package:game/actors/actor.dart';
import 'package:game/actors/managers/movement_manager.dart';
import 'package:game/main.dart';
import 'package:game/skills/types/skill.dart';
import 'package:game/utils/settings/logs.dart';

import '../../skills/dash.dart';
import '../../skills/types/enums.dart';

class SkillManager {
  final SpriteAnimationGroupComponent actor;
  final MovementManager movementManager;
  final List<Skill> equippedSkills;
  late final Queue<Skill> skillsQueue;

  bool isExecutingSkill = false;
  bool currentSkillHasBeenDashInterrupted = false;

  SkillManager({
    required this.actor,
    required this.movementManager,
    required this.equippedSkills,
  }) {
    skillsQueue = Queue<Skill>();
  }

  void handleSkillsQueue() {
    final bool enqueuedSkillIsDash = skillsQueue.isNotEmpty && skillsQueue.first is Dash;
    if ((skillsQueue.isNotEmpty && !isExecutingSkill || enqueuedSkillIsDash)) {
      // If the next skill in the queue is a dash and the current skill is executing
      // then the current skill has been interrupted by the dash
      if (enqueuedSkillIsDash && isExecutingSkill) {
        currentSkillHasBeenDashInterrupted = true;

        // Reset flags and stored velocity
        isExecutingSkill = false;
        movementManager.isInUninterruptibleAnimation = false;
        movementManager.isInStoppingAnimation = false;
        movementManager.direction.setFrom(movementManager.storedDirection);
        movementManager.storedDirection.setZero();
        actor.current = ActorState.idle;

        if (LogSettings.shouldLogMovement) {
          logger.d('Dash interrupted current skill\nVelocity: ${movementManager.direction}\nStored velocity: ${movementManager.storedDirection}');
        }
      }

      final Skill skill = skillsQueue.removeFirst(); // Dequeue first skill
      skill.execute();

      _logSkillQueue(skill.name, false);
    }
  }

  void loadSkillIntoQueue<S>() {
    final Skill skill = equippedSkills.firstWhere((skill) => skill is S);
    if (skill.isOnCoolDown) return;
    skillsQueue.add(skill);

    _logSkillQueue(skill.name, true);
  }

  void onSkillStart({required SkillType skillType, bool isUninterruptibleAnimation = false, bool isStoppingAnimation = false, ActorState? actorState}) {
    isExecutingSkill = true;

    movementManager.isInUninterruptibleAnimation = isUninterruptibleAnimation;

    if (isUninterruptibleAnimation) {
      movementManager.storedDirection.setFrom(movementManager.direction);
    }

    movementManager.isInStoppingAnimation = isStoppingAnimation;

    if (actorState != null) {
      actor.current = actorState;
    }
  }

  void onSkillEnd({required SkillType skillType, bool wasUninterruptibleAnimation = false, bool wasStoppingAnimation = false, bool wasDashInterrupted = false}) {
    if (wasDashInterrupted) {
      currentSkillHasBeenDashInterrupted = false;
      return;
    }

    if (wasUninterruptibleAnimation) {
      movementManager.isInUninterruptibleAnimation = false;
      movementManager.direction.setFrom(movementManager.storedDirection);
      movementManager.storedDirection.setZero();

      if (LogSettings.shouldLogMovement) {
        logger.d('Skill ended, Type: ${skillType.name}\nVelocity: ${movementManager.direction}\nStored velocity: ${movementManager.storedDirection}');
      }
    }

    if (wasStoppingAnimation) {
      movementManager.isInStoppingAnimation = false;
    }

    actor.current = ActorState.idle;

    isExecutingSkill = false;
  }

  void update(double dt) {
    handleSkillsQueue();
  }

  void _logSkillQueue(String skillName, bool isEnqueued) {
    if (!LogSettings.shouldLogSkillQueue) return;
    final List<String?> skillNames = skillsQueue.map((skill) => skill.name).toList();
    final String enqueued = isEnqueued ? 'Enqueued' : 'Dequeued';
    logger.d('$enqueued skill: $skillName\nQueue: $skillNames');
  }
}
