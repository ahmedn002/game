import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game/game.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(GameWidget(game: MyGame()));
}
