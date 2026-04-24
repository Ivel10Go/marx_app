import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class SkeletonCard extends StatefulWidget {
  const SkeletonCard({super.key});

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final shimmer = Color.lerp(
          AppColors.paperDark,
          AppColors.rule,
          _anim.value,
        )!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Kicker skeleton
            Container(
              height: 34,
              color: AppColors.red.withValues(alpha: 0.15 + 0.1 * _anim.value),
            ),
            // Card body skeleton
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.paper,
                border: Border(
                  left: BorderSide(color: AppColors.ink, width: 1),
                  right: BorderSide(color: AppColors.ink, width: 1),
                  bottom: BorderSide(color: AppColors.ink, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _SkeletonLine(color: shimmer, width: double.infinity),
                  const SizedBox(height: 10),
                  _SkeletonLine(color: shimmer, width: double.infinity),
                  const SizedBox(height: 10),
                  _SkeletonLine(color: shimmer, width: 220),
                  const SizedBox(height: 10),
                  _SkeletonLine(color: shimmer, width: 170),
                  const SizedBox(height: 18),
                  Container(width: 28, height: 2, color: shimmer),
                  const SizedBox(height: 14),
                  _SkeletonLine(color: shimmer, width: 120),
                  const SizedBox(height: 18),
                  Row(
                    children: <Widget>[
                      _SkeletonChip(color: shimmer),
                      const SizedBox(width: 8),
                      _SkeletonChip(color: shimmer, width: 60),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.color, required this.width});
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 13,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.zero,
      ),
    );
  }
}

class _SkeletonChip extends StatelessWidget {
  const _SkeletonChip({required this.color, this.width = 80});
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: width,
      color: color,
    );
  }
}
