import 'dart:ui';

import 'package:flame/components.dart';
import 'package:game/actors/actor.dart';

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

  void setAnimationMap(Map<ActorState, SpriteAnimation> animations) {
    actor.animations = animations;
  }

  void setCurrentAnimation(ActorState state) {
    actor.current = state;
  }
}

class Animation {
  final int frameCount;
  final double frameDuration;
  final Image image;
  final Vector2 size;
  late Vector2? position;

  Animation({
    required this.frameCount,
    required this.frameDuration,
    required this.image,
    required this.size,
    this.position,
  }) {
    position ??= Vector2.zero();
  }

  SpriteAnimation load() {
    return SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: frameCount,
        textureSize: size,
        stepTime: frameDuration,
        texturePosition: position,
      ),
    );
  }
}
