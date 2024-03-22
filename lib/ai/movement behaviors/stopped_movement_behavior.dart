import 'package:game/ai/movement%20behaviors/movement_behavior.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;

class StoppedMovementBehavior extends MovementBehavior {
  StoppedMovementBehavior({required super.actor, required super.movementSpeed});
  @override
  Vector2 calculateDirection() => Vector2.zero();
}
