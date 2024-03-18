import 'package:flutter/foundation.dart';

class LogSettings {
  static bool shouldLogSpawns = false && kDebugMode;
  static bool shouldLogMovement = false && kDebugMode;
  static bool shouldLogKeyPresses = false && kDebugMode;
  static bool shouldLogSkillExecution = false;
  static bool shouldLogSkillQueue = false;
}
