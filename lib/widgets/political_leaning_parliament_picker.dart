import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';
import '../data/models/user_profile.dart';

class PoliticalLeaningParliamentPicker extends StatelessWidget {
  const PoliticalLeaningParliamentPicker({
    required this.selected,
    required this.onSelect,
    this.height = 150,
    super.key,
  });

  final PoliticalLeaning selected;
  final ValueChanged<PoliticalLeaning> onSelect;
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : 320.0;
        final labels = <PoliticalLeaning>[
          PoliticalLeaning.left,
          PoliticalLeaning.centerLeft,
          PoliticalLeaning.neutral,
          PoliticalLeaning.liberal,
          PoliticalLeaning.conservative,
        ];
        const labelAreaHeight = 30.0;
        final contentHeight = math.max(height - labelAreaHeight, 96.0);
        final availableWidth = width;
        final radius = math.min(availableWidth / 2 - 8, contentHeight - 10);
        final center = Offset(availableWidth / 2, contentHeight);
        final selectedIndex = _indexForLeaning(selected);

        return SizedBox(
          width: double.infinity,
          height: height,
          child: Column(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (details) => _handleTap(
                      tapPosition: details.localPosition,
                      labels: labels,
                      center: center,
                      radius: radius,
                      onSelect: onSelect,
                    ),
                    child: CustomPaint(
                      size: Size(availableWidth, contentHeight),
                      painter: _ParliamentBackgroundPainter(
                        selectedIndex: selectedIndex,
                        center: center,
                        radius: radius,
                        sectorCount: labels.length,
                        colors: labels.map(_colorForLeaning).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 24,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _labelFor(selected),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleTap({
    required Offset tapPosition,
    required List<PoliticalLeaning> labels,
    required Offset center,
    required double radius,
    required ValueChanged<PoliticalLeaning> onSelect,
  }) {
    final dx = tapPosition.dx - center.dx;
    final dy = tapPosition.dy - center.dy;
    final distance = math.sqrt((dx * dx) + (dy * dy));

    if (distance > radius) {
      return;
    }

    // Only the upper half-circle is interactive.
    if (tapPosition.dy > center.dy) {
      return;
    }

    var angle = math.atan2(dy, dx);
    // Map left..right of the upper half to a 0..1 range.
    if (angle > 0) {
      angle -= 2 * math.pi;
    }
    final progress = ((angle + math.pi) / math.pi).clamp(0.0, 1.0);
    final index = (progress * labels.length).floor().clamp(
      0,
      labels.length - 1,
    );
    onSelect(labels[index]);
  }

  int _indexForLeaning(PoliticalLeaning leaning) {
    switch (leaning) {
      case PoliticalLeaning.left:
        return 0;
      case PoliticalLeaning.centerLeft:
        return 1;
      case PoliticalLeaning.neutral:
        return 2;
      case PoliticalLeaning.liberal:
        return 3;
      case PoliticalLeaning.conservative:
        return 4;
    }
  }

  Color _colorForLeaning(PoliticalLeaning leaning) {
    switch (leaning) {
      case PoliticalLeaning.left:
        return const Color(0xFF7A120E);
      case PoliticalLeaning.centerLeft:
        return AppColors.redDark;
      case PoliticalLeaning.neutral:
        return const Color(0xFF3DBB66);
      case PoliticalLeaning.liberal:
        return const Color(0xFFF2D44F);
      case PoliticalLeaning.conservative:
        return AppColors.ink;
    }
  }

  String _labelFor(PoliticalLeaning leaning) {
    switch (leaning) {
      case PoliticalLeaning.left:
        return 'Links';
      case PoliticalLeaning.centerLeft:
        return 'Mitte-Links';
      case PoliticalLeaning.neutral:
        return 'Neutral';
      case PoliticalLeaning.liberal:
        return 'Liberal';
      case PoliticalLeaning.conservative:
        return 'Konservativ';
    }
  }
}

class _ParliamentBackgroundPainter extends CustomPainter {
  const _ParliamentBackgroundPainter({
    required this.selectedIndex,
    required this.center,
    required this.radius,
    required this.sectorCount,
    required this.colors,
  });

  final int selectedIndex;
  final Offset center;
  final double radius;
  final int sectorCount;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    // Enforce a clean upper half only.
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, center.dy));

    final sectorPaint = Paint()..style = PaintingStyle.fill;

    final segmentAngle = math.pi / sectorCount;
    for (var index = 0; index < sectorCount; index++) {
      final startAngle = math.pi + (segmentAngle * index);
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          segmentAngle,
          false,
        )
        ..close();

      final isActive = index == selectedIndex;
      sectorPaint.color = colors[index].withValues(
        alpha: isActive ? 0.86 : 0.42,
      );
      canvas.drawPath(path, sectorPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ParliamentBackgroundPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.center != center ||
        oldDelegate.radius != radius ||
        oldDelegate.sectorCount != sectorCount ||
        oldDelegate.colors != colors;
  }
}
