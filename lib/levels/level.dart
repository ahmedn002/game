import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game/actors/player.dart';

class Level extends World {
  late TiledComponent level;

  final String levelName;
  final Player player;

  Level({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    final spawnPoints = level.tileMap.getLayer<ObjectGroup>('Spawns');
    for (final spawnPoint in spawnPoints!.objects) {
      if (spawnPoint.class_ == 'Player') {
        player.position = Vector2(spawnPoint.x, spawnPoint.y);
        add(player);
      }
    }
    return super.onLoad();
  }
}
