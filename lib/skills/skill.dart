import 'package:my_game/actors/actor.dart';

abstract class Skill {
  final String name;
  final String description;
  final double coolDown;
  final Actor actor;
  final Actor? target;

  Skill({
    required this.name,
    required this.description,
    required this.coolDown,
    required this.actor,
    this.target,
  });

  void execute();
}
