import 'package:flame/components.dart';

abstract class Actor {
  String get name;
  double get health;
  double get maxHealth;
  Vector2 get velocity;
  Vector2 get position;
  double get movementSpeed;

  void onSkillStart(SkillType skillType);
  void onSkillEnd(SkillType skillType);
}

enum SkillType {
  dash,
  attack,
  heal,
  buff,
  debuff,
}
