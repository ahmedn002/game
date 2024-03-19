import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

class HealthBar extends PositionComponent {
  final double maxHealth;
  final double Function() updateHealth;
  final bool Function() shouldFlip; // If parent is flipped due to direction, flip the health bar
  late double currentHealth;
  final Vector2 barSize;

  HealthBar({
    required this.maxHealth,
    required this.updateHealth,
    required this.shouldFlip,
    required this.barSize,
  }) {
    currentHealth = maxHealth;
  }

  @override
  FutureOr<void> onLoad() {
    size = barSize;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    currentHealth = updateHealth();

    if (shouldFlip()) {
      if (!isFlippedHorizontally) {
        flipHorizontallyAroundCenter();
      }
    } else {
      if (isFlippedHorizontally) {
        flipHorizontallyAroundCenter();
      }
    }

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    final Paint paint = Paint()
      ..color = const Color(0xFFA12222)
      ..style = PaintingStyle.fill;

    final double healthPercentage = currentHealth / maxHealth;
    final double healthBarWidth = size.x * healthPercentage;

    canvas.drawRect(
      Rect.fromLTWH(0, -3, healthBarWidth, size.y),
      paint,
    );

    // Border
    canvas.drawRect(
      Rect.fromLTWH(0, -3, size.x, size.y),
      paint
        ..color = const Color(0xFF1A1A1A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    super.render(canvas);
  }
}
