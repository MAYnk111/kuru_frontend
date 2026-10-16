import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../data/models/career_assessment_model.dart';
import 'skill_detail_sheet.dart';

class SkillGraphWidget extends StatelessWidget {
  final List<SkillModel> skills;
  final VoidCallback? onViewFullGraph;

  const SkillGraphWidget({
    super.key,
    required this.skills,
    this.onViewFullGraph,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderCream),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Skill Graph',
                style: AppTypography.titleMedium(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: onViewFullGraph,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View Full Graph',
                  style: AppTypography.tag(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Interactive Network Graph Canvas
          SizedBox(
            height: 220,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                final center = Offset(w / 2, h / 2);

                // Nodes positions relative to center
                final nodePositions = [
                  Offset(center.dx - 65, center.dy - 65), // Python (top-left)
                  Offset(center.dx + 65, center.dy - 60), // Machine Learning (top-right)
                  Offset(center.dx - 100, center.dy + 40), // React (mid-left)
                  Offset(center.dx - 20, center.dy + 65), // FastAPI (bottom-mid)
                  Offset(center.dx + 60, center.dy + 65), // Cloud (bottom-right)
                  Offset(center.dx + 105, center.dy + 25), // System Design (far-right)
                ];

                return Stack(
                  children: [
                    // Network Connection Lines
                    CustomPaint(
                      size: Size(w, h),
                      painter: _GraphLinesPainter(
                        center: center,
                        nodePositions: nodePositions,
                      ),
                    ),

                    // Center "You" Node
                    Positioned(
                      left: center.dx - 22,
                      top: center.dy - 22,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primaryNavy,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.antiqueGold, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryNavy.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'You',
                            style: AppTypography.tag(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Orbiting Skill Nodes
                    ...List.generate(
                      math.min(skills.length, nodePositions.length),
                      (index) {
                        final skill = skills[index];
                        final pos = nodePositions[index];
                        final color = _getNodeColor(index);

                        return Positioned(
                          left: pos.dx - 20,
                          top: pos.dy - 20,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => SkillDetailSheet(skill: skill),
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withOpacity(0.35),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _getNodeIcon(skill.name),
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  skill.name,
                                  style: AppTypography.tag(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getNodeColor(int index) {
    const colors = [
      Color(0xFF2962FF), // Python Blue
      Color(0xFF00C853), // ML Green
      Color(0xFF0288D1), // React Blue
      Color(0xFF00897B), // FastAPI Teal
      Color(0xFFF57C00), // Cloud Orange
      Color(0xFF7E57C2), // System Design Purple
    ];
    return colors[index % colors.length];
  }

  IconData _getNodeIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('python')) return Icons.code;
    if (lower.contains('react')) return Icons.widgets_outlined;
    if (lower.contains('fastapi')) return Icons.bolt;
    if (lower.contains('learning') || lower.contains('ml')) return Icons.psychology;
    if (lower.contains('cloud') || lower.contains('aws')) return Icons.cloud_outlined;
    if (lower.contains('system')) return Icons.dns;
    return Icons.star_border;
  }
}

class _GraphLinesPainter extends CustomPainter {
  final Offset center;
  final List<Offset> nodePositions;

  _GraphLinesPainter({required this.center, required this.nodePositions});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.borderCream
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppColors.antiqueGold.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (final pos in nodePositions) {
      canvas.drawLine(center, pos, linePaint);
      final midPoint = Offset((center.dx + pos.dx) / 2, (center.dy + pos.dy) / 2);
      canvas.drawCircle(midPoint, 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GraphLinesPainter oldDelegate) => true;
}
