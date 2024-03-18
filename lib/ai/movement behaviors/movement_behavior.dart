import 'package:flame/components.dart';
import 'package:game/actors/actor.dart';

abstract class MovementBehavior {
  final Actor actor;
  final double movementSpeed;

  MovementBehavior({required this.actor, required this.movementSpeed});

  Vector2 calculateVelocity();
}
