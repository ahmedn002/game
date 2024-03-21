import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: MyCustomPainter(),
              ),
            ),
            const Text(
              'Hello, world!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width / 2, size.height / 5)
      ..cubicTo(
        size.width / 5,
        0,
        0,
        size.height / 3.5,
        size.width / 2,
        size.height,
      )
      ..cubicTo(
        size.width,
        size.height / 3.5,
        size.width * 4 / 5,
        0,
        size.width / 2,
        size.height / 5,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 30,
    );
    final textSpan = TextSpan(
      text: 'Hello, world!',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset = Offset(size.width / 2, size.height / 2);
    final paint = BasicPalette.white.paint();
    final srcOverPaint = Paint()..blendMode = BlendMode.difference;
    canvas.saveLayer(null, srcOverPaint);
    textPainter.paint(canvas, offset);
    canvas.drawPaint(paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
