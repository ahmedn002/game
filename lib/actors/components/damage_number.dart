import 'dart:async' as async;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/text.dart';
import 'package:flutter/animation.dart';

class DamageNumber extends TextComponent {
  final double damage;
  double opacity = 1.0;
  final TextPaint textPaint = TextPaint(
    style: const TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: 12,
      fontFamily: 'Dogica',
    ),
  );

  DamageNumber(this.damage) : super(text: damage.round().toString()) {
    textRenderer = textPaint;
  }

  @override
  async.FutureOr<void> onLoad() {
    addAll(
      [
        MoveAlongPathEffect(
          Path()..quadraticBezierTo(25, 0, 15, 15),
          EffectController(
            duration: 0.5,
            curve: Curves.easeOutExpo,
          ),
        )
      ],
    );

    // async.Timer.periodic(
    //   const Duration(milliseconds: 20),
    //   (timer) {
    //     opacity -= 0.1;
    //     if (opacity <= 0) {
    //       timer.cancel();
    //       removeFromParent();
    //     }
    //   },
    // );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    textRenderer = TextPaint(
      style: TextStyle(
        color: const Color(0xFFFFFFFF).withOpacity(opacity),
        fontSize: 12,
        fontFamily: 'Dogica',
      ),
    );

    super.update(dt);
  }
}
