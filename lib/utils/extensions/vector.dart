import 'package:flame/components.dart';

extension VectorExtensions on Vector2 {
  bool get isDiagonal => x != 0 && y != 0;

  int get horizontalFactor {
    if (x > 0) {
      return 1;
    } else if (x < 0) {
      return -1;
    } else {
      return 0;
    }
  }

  int get verticalFactor {
    if (y > 0) {
      return 1;
    } else if (y < 0) {
      return -1;
    } else {
      return 0;
    }
  }
}
