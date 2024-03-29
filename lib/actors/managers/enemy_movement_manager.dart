import 'package:flame/components.dart';
import 'package:game/actors/actor.dart';

import '../../ai/movement behaviors/circulating_movement_behavior.dart';
import '../../ai/movement behaviors/following_movement_behavior.dart';
import '../../ai/movement behaviors/movement_behavior.dart';
import '../../ai/movement behaviors/stopped_movement_behavior.dart';
import 'movement_manager.dart';

class EnemyMovementManager extends MovementManager {
  final Actor player;

  late MovementBehavior movementBehavior;

  late final FollowingMovementBehavior followingMovementBehavior;
  late final CirculatingMovementBehavior circulatingMovementBehavior;
  late final StoppedMovementBehavior stoppedMovementBehavior;

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
    stoppedMovementBehavior = StoppedMovementBehavior(
      actor: actor,
      movementSpeed: movementSpeed,
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

    direction.setFrom(movementBehavior.calculateDirection());
    velocity.setFrom(direction * movementSpeed);
    super.update(dt);

    actor.position += velocity * dt;

    if (velocity.isZero()) {
      actor.current = ActorState.idle;
    } else {
      actor.current = ActorState.running;
    }
  }

  double _distanceToPlayer() {
    return actor.position.distanceTo(player.position);
  }
}
