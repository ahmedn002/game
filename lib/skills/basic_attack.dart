import 'package:flame/components.dart';
import 'package:flame/layout.dart';
import 'package:game/actors/actor.dart';
import 'package:game/actors/components/damaging_hitbox.dart';
import 'package:game/skills/types/aoe_attack.dart';
import 'package:game/skills/types/enums.dart';

class BasicAttack extends AOEAttack {
  BasicAttack({
    required super.actor,
  }) : super(
          name: 'Attack',
          description: 'Attack the target',
          type: SkillType.attack,
          coolDown: 1000,
          isUninterruptibleAnimation: true,
          isStoppingAnimation: true,
          actorState: ActorState.attacking,
          damage: 10,
          damageType: DamageType.physical,
        );

  @override
  void action({final Actor? target}) async {
    actor.skillManager.onSkillStart(
      skillType: type,
      isUninterruptibleAnimation: isUninterruptibleAnimation,
      isStoppingAnimation: isStoppingAnimation,
      actorState: actorState,
    );
    await Future.delayed(const Duration(milliseconds: 500));

    final Component hitBox = AlignComponent(
      alignment: Anchor.bottomRight,
      child: DamagingHitbox(
        skill: this,
        size: Vector2(actor.width * 0.3, actor.height * 0.7),
        // Downward attack
        attackForceDirection: Vector2(0, 1),
      ),
    );

    actor.add(hitBox);

    await Future.delayed(const Duration(milliseconds: 200));

    actor.remove(hitBox);

    actor.skillManager.onSkillEnd(
      skillType: type,
      wasUninterruptibleAnimation: isUninterruptibleAnimation,
      wasStoppingAnimation: isStoppingAnimation,
      wasDashInterrupted: actor.skillManager.currentSkillHasBeenDashInterrupted,
    );
  }

  @override
  double calculateDamageWithModifiers() {
    return 10;
  }
}
