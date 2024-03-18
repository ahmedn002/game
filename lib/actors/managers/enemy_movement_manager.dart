import 'package:flame/components.dart';
import 'package:game/actors/actor.dart';

import '../../ai/movement behaviors/circulating_movement_behavior.dart';
import '../../ai/movement behaviors/following_movement_behavior.dart';
import '../../ai/movement behaviors/movement_behavior.dart';
import 'movement_manager.dart';

class EnemyMovementManager extends MovementManager {
  final Actor player;

  late MovementBehavior movementBehavior;

  late final FollowingMovementBehavior followingMovementBehavior;
  late final CirculatingMovementBehavior circulatingMovementBehavior;

  EnemyMovementManager({
    required super.actor,
    required this.player,
  }) : super(movementSpeed: 50) {
    followingMovementBehavior = FollowingMovementBehavior(
      actor: actor,
      movementSpeed: movementSpeed,
      target: player,
    );
    circulatingMovementBehavior = CirculatingMovementBehavior(
      actor: actor,
      movementSpeed: movementSpeed,
      target: player,
    );
    movementBehavior = followingMovementBehavior;
  }

  @override
  void update(double dt) {
    if (_distanceToPlayer() > 20) {
      movementBehavior = followingMovementBehavior;
    } else {
      movementBehavior = circulatingMovementBehavior;
    }

    direction.setFrom(movementBehavior.calculateVelocity());

    actor.position += direction * dt;

    if (direction.isZero()) {
      actor.current = ActorState.idle;
    } else {
      actor.current = ActorState.running;
    }

    super.update(dt);
  }

  double _distanceToPlayer() {
    return actor.position.distanceTo(player.position);
  }
}
