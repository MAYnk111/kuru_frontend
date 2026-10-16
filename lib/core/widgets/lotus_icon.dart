import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Restrained Vedic Lotus motif linework widget
class LotusMotif extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double strokeWidth;

  const LotusMotif({
    super.key,
    this.width = 64,
    this.height = 48,
    this.color = AppColors.antiqueGold,
    this.strokeWidth = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _LotusPainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _LotusPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _LotusPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h * 0.85;

    // Center petal
    final centerPetal = Path()
      ..moveTo(cx, cy)
      ..quadraticBezierTo(cx - w * 0.12, h * 0.45, cx, h * 0.1)
      ..quadraticBezierTo(cx + w * 0.12, h * 0.45, cx, cy);
    canvas.drawPath(centerPetal, paint);

    // Inner left petal
    final innerLeft = Path()
      ..moveTo(cx - w * 0.04, cy)
      ..quadraticBezierTo(cx - w * 0.28, h * 0.4, cx - w * 0.18, h * 0.22)
      ..quadraticBezierTo(cx - w * 0.08, h * 0.45, cx, cy);
    canvas.drawPath(innerLeft, paint);

    // Inner right petal
    final innerRight = Path()
      ..moveTo(cx + w * 0.04, cy)
      ..quadraticBezierTo(cx + w * 0.28, h * 0.4, cx + w * 0.18, h * 0.22)
      ..quadraticBezierTo(cx + w * 0.08, h * 0.45, cx, cy);
    canvas.drawPath(innerRight, paint);

    // Outer left petal
    final outerLeft = Path()
      ..moveTo(cx - w * 0.08, cy)
      ..quadraticBezierTo(cx - w * 0.45, h * 0.55, cx - w * 0.35, h * 0.4)
      ..quadraticBezierTo(cx - w * 0.2, h * 0.6, cx, cy);
    canvas.drawPath(outerLeft, paint);

    // Outer right petal
    final outerRight = Path()
      ..moveTo(cx + w * 0.08, cy)
      ..quadraticBezierTo(cx + w * 0.45, h * 0.55, cx + w * 0.35, h * 0.4)
      ..quadraticBezierTo(cx + w * 0.2, h * 0.6, cx, cy);
    canvas.drawPath(outerRight, paint);

    // Lotus base arc
    final baseArc = Path()
      ..moveTo(cx - w * 0.3, cy + h * 0.04)
      ..quadraticBezierTo(cx, cy + h * 0.12, cx + w * 0.3, cy + h * 0.04);
    canvas.drawPath(baseArc, paint);
  }

  @override
  bool shouldRepaint(covariant _LotusPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
