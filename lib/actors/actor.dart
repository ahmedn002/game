import 'package:flame/components.dart';
import 'package:game/actors/components/movement_manager.dart';
import 'package:game/actors/components/skill_manager.dart';
import 'package:game/actors/components/sprite_loader.dart';

abstract class Actor extends SpriteAnimationGroupComponent {
  final String name;
  final double health;
  final double maxHealth;

  late final SpriteManager spriteManager;
  late final MovementManager movementManager;
  late final SkillManager skillManager;

  Actor({
    required this.name,
    required this.health,
    required this.maxHealth,
  });
}

enum SkillType {
  dash,
  attack,
  heal,
  buff,
  debuff,
}
