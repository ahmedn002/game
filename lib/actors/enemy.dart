import 'package:game/actors/player.dart';

import 'actor.dart';

abstract class Enemy extends Actor {
  final Player player;

  Enemy({
    required super.name,
    required super.health,
    required super.maxHealth,
    required this.player,
  });
}
