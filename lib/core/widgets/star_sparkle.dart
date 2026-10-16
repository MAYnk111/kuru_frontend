import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Refined 4-point Vedic star sparkle matching the top quote banner
class StarSparkle extends StatelessWidget {
  final double size;
  final Color color;

  const StarSparkle({
    super.key,
    this.size = 18,
    this.color = AppColors.antiqueGold,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _StarPainter(color: color),
    );
  }
}

class _StarPainter extends CustomPainter {
  final Color color;
  _StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final rOuter = size.width / 2;
    final rInner = size.width / 7;

    for (int i = 0; i < 4; i++) {
      final angle = (i * 90) * math.pi / 180;
      final nextAngle = ((i * 90) + 45) * math.pi / 180;

      final xOuter = cx + rOuter * math.cos(angle - math.pi / 2);
      final yOuter = cy + rOuter * math.sin(angle - math.pi / 2);

      final xInner = cx + rInner * math.cos(nextAngle - math.pi / 2);
      final yInner = cy + rInner * math.sin(nextAngle - math.pi / 2);

      if (i == 0) {
        path.moveTo(xOuter, yOuter);
      } else {
        path.lineTo(xOuter, yOuter);
      }
      path.lineTo(xInner, yInner);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => oldDelegate.color != color;
}
