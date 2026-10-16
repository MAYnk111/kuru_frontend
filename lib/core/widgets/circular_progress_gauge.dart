import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

class CircularReadinessGauge extends StatefulWidget {
  final int score;
  final List<GaugeCategoryNode> categories;
  final ValueChanged<GaugeCategoryNode>? onCategoryTap;

  const CircularReadinessGauge({
    super.key,
    required this.score,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  State<CircularReadinessGauge> createState() => _CircularReadinessGaugeState();
}

class _CircularReadinessGaugeState extends State<CircularReadinessGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CircularReadinessGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentScore = (widget.score * _animation.value).round();
        return SizedBox(
          width: 320,
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer connecting tracks and nodes
              CustomPaint(
                size: const Size(320, 250),
                painter: _GaugeBackgroundPainter(
                  scoreRatio: (_animation.value * widget.score) / 100,
                ),
              ),

              // Center Circular Readiness Disc
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryNavy,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryNavy.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.antiqueGold.withOpacity(0.6),
                    width: 2.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$currentScore',
                          style: AppTypography.displayBold(
                            fontSize: 34,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '%',
                          style: AppTypography.titleMedium(
                            fontSize: 18,
                            color: AppColors.antiqueGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Career Readiness',
                      style: AppTypography.bodySmall(
                        fontSize: 10.5,
                        color: AppColors.textOnNavySecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Category Nodes positioned around the circular gauge
              ..._buildCategoryNodes(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildCategoryNodes() {
    final nodes = <Widget>[];

    // Node 1: Problem Solving (Top - 12 o'clock)
    nodes.add(
      Positioned(
        top: 2,
        child: _CategoryPill(
          icon: Icons.psychology_outlined,
          label: 'Problem\nSolving',
          onTap: () => _handleTap('Problem Solving'),
        ),
      ),
    );

    // Node 2: Programming (Left - 9 o'clock)
    nodes.add(
      Positioned(
        left: 8,
        top: 75,
        child: _CategoryPill(
          icon: Icons.code,
          label: 'Programming',
          onTap: () => _handleTap('Programming'),
        ),
      ),
    );

    // Node 3: System Design (Right - 3 o'clock)
    nodes.add(
      Positioned(
        right: 8,
        top: 75,
        child: _CategoryPill(
          icon: Icons.dns_outlined,
          label: 'System\nDesign',
          onTap: () => _handleTap('System Design'),
        ),
      ),
    );

    // Node 4: Tools & Frameworks (Bottom Left)
    nodes.add(
      Positioned(
        left: 20,
        bottom: 8,
        child: _CategoryPill(
          icon: Icons.build_outlined,
          label: 'Tools &\nFrameworks',
          onTap: () => _handleTap('Tools & Frameworks'),
        ),
      ),
    );

    // Node 5: Communication (Bottom Right)
    nodes.add(
      Positioned(
        right: 20,
        bottom: 8,
        child: _CategoryPill(
          icon: Icons.groups_outlined,
          label: 'Communication',
          onTap: () => _handleTap('Communication'),
        ),
      ),
    );

    return nodes;
  }

  void _handleTap(String categoryName) {
    final match = widget.categories.firstWhere(
      (c) => c.name.toLowerCase() == categoryName.toLowerCase(),
      orElse: () => GaugeCategoryNode(name: categoryName, icon: Icons.star, level: 75),
    );
    widget.onCategoryTap?.call(match);
  }
}

class _CategoryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CategoryPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.secondaryNavy,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.antiqueGold.withOpacity(0.5), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.antiqueGold, size: 19),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.tag(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class GaugeCategoryNode {
  final String name;
  final IconData icon;
  final int level;

  GaugeCategoryNode({
    required this.name,
    required this.icon,
    required this.level,
  });
}

class _GaugeBackgroundPainter extends CustomPainter {
  final double scoreRatio;

  _GaugeBackgroundPainter({required this.scoreRatio});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 76.0;

    // Outer subtle dashed/dotted orbit track
    final trackPaint = Paint()
      ..color = AppColors.borderCream
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius + 14, trackPaint);

    // Active progress arc
    final progressPaint = Paint()
      ..color = AppColors.antiqueGold
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * scoreRatio;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 14),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugeBackgroundPainter oldDelegate) =>
      oldDelegate.scoreRatio != scoreRatio;
}
