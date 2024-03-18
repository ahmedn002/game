import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game/actors/orc.dart';
import 'package:game/actors/player.dart';
import 'package:game/main.dart';
import 'package:game/utils/settings/logs.dart';

class Level extends World {
  late TiledComponent level;

  final String levelName;

  Level({required this.levelName});

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    final spawnPoints = level.tileMap.getLayer<ObjectGroup>('Spawns');
    final Player player = Player();

    if (LogSettings.shouldLogSpawns) {
      logger.i('Spawn Classes: ${spawnPoints!.objects.map((e) => e.class_).toList()}');
    }

    for (final spawnPoint in spawnPoints!.objects) {
      if (spawnPoint.class_ == 'Player') {
        if (LogSettings.shouldLogSpawns) {
          logger.i('Spawning Player at Class ${spawnPoint.class_} (${spawnPoint.x}, ${spawnPoint.y})');
        }
        player.position = Vector2(spawnPoint.x, spawnPoint.y);
        add(player);
      }

      if (spawnPoint.class_ == 'Enemy 1') {
        if (LogSettings.shouldLogSpawns) {
          logger.i('Spawning Orc at Class ${spawnPoint.class_} (${spawnPoint.x}, ${spawnPoint.y})');
        }
        final Orc orc = Orc(player: player);
        orc.position = Vector2(spawnPoint.x, spawnPoint.y);
        add(orc);
      }
    }
    return super.onLoad();
  }
}
