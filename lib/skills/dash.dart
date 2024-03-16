import 'package:my_game/skills/skill.dart';

class Dash extends Skill {
  final double range = 100.0;

  Dash({
    required super.actor,
  }) : super(name: 'Dash', description: 'Dash forward', coolDown: 1.0);

  @override
  void execute() {}
}
