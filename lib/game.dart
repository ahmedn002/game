import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game/levels/level.dart';

class MyGame extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks {
  late final World level;
  late final JoystickComponent joystick;
  final bool useJoystick = false;

  @override
  Color backgroundColor() {
    return Colors.grey;
  }

  @override
  FutureOr<void> onLoad() async {
    debugMode = false;

    await images.loadAllImages();
    _createLevel();
    _initCamera();
    if (useJoystick) _addJoyStick();

    addAll(<Component>[level, camera]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (useJoystick) _updateJoystick();
    super.update(dt);
  }

  void _updateJoystick() {
    // final bool movingLeft = [
    //   JoystickDirection.left,
    //   JoystickDirection.downLeft,
    //   JoystickDirection.upLeft,
    // ].contains(joystick.direction);
    //
    // final bool movingRight = [
    //   JoystickDirection.right,
    //   JoystickDirection.downRight,
    //   JoystickDirection.upRight,
    // ].contains(joystick.direction);

    // if (movingLeft) {
    //   player.direction = PlayerDirection.left;
    // } else if (movingRight) {
    //   player.direction = PlayerDirection.right;
    // } else {
    //   player.direction = PlayerDirection.none;
    // }
  }

  void _createLevel() {
    level = Level(levelName: 'level-01');
  }

  void _initCamera() {
    camera = CameraComponent.withFixedResolution(world: level, width: 640, height: 360);
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.priority = 2;
  }

  void _addJoyStick() {
    joystick = JoystickComponent(
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
      ),
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Knob.png')),
      ),
      margin: const EdgeInsets.only(bottom: 20, left: 20),
      anchor: Anchor.bottomLeft,
      priority: 3,
    );

    add(joystick);
  }
}
