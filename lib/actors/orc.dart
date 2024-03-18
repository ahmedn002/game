import 'package:flame/components.dart';
import 'package:game/actors/enemy.dart';
import 'package:game/actors/managers/enemy_movement_manager.dart';
import 'package:game/actors/managers/movement_manager.dart';
import 'package:game/actors/managers/skill_manager.dart';
import 'package:game/actors/managers/sprite_loader.dart';
import 'package:game/game.dart';

class Orc extends Enemy with HasGameRef<MyGame> {
  Orc({required super.player}) : super(name: 'Orc', health: 100, maxHealth: 100);

  @override
  MovementManager loadMovementManager() {
    return EnemyMovementManager(
      actor: this,
      player: player,
    );
  }

  @override
  SkillManager loadSkillManager() {
    return SkillManager(
      actor: this,
      movementManager: movementManager,
      equippedSkills: [],
    );
  }

  @override
  SpriteManager loadSpriteManager() {
    const String spritesPath = 'Heroes/Cloak';
    return SpriteManager(
      actor: this,
      idleAnimationData: Animation(
        frameCount: 2,
        frameDuration: .2,
        image: game.images.fromCache('$spritesPath/IDLE.png'),
        size: Vector2.all(32),
      ),
      runAnimationData: Animation(
        frameCount: 8,
        frameDuration: 0.1,
        image: game.images.fromCache('$spritesPath/RUN.png'),
        size: Vector2.all(32),
      ),
      attackAnimationData: Animation(
        frameCount: 8,
        frameDuration: 0.1,
        image: game.images.fromCache('$spritesPath/ATTACK.png'),
        size: Vector2.all(32),
      ),
    );
  }
}
