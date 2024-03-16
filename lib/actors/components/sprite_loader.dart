import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:my_game/actors/actor.dart';

class SpriteManager {
  final Actor actor;

  final Animation idleAnimationData;
  final Animation runAnimationData;
  final Animation attackAnimationData;

  late SpriteAnimation idleAnimation;
  late SpriteAnimation runAnimation;
  late SpriteAnimation attackAnimation;

  SpriteManager({
    required this.actor,
    required this.idleAnimationData,
    required this.runAnimationData,
    required this.attackAnimationData,
  }) {
    idleAnimation = idleAnimationData.load();
    runAnimation = runAnimationData.load();
    attackAnimation = attackAnimationData.load();
  }
}

class Animation {
  final String path;
  final int frameCount;
  final double frameDuration;
  final Game game;

  Animation({
    required this.path,
    required this.frameCount,
    required this.frameDuration,
    required this.game,
  });

  SpriteAnimation load() {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(path),
      SpriteAnimationData.sequenced(
        amount: frameCount,
        textureSize: Vector2.all(96),
        stepTime: frameDuration,
      ),
    );
  }
}
