import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/godmode_colors.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({
    required this.days,
    this.expanded = false,
    this.isGodmode = false,
    super.key,
  });

  final int days;
  final bool expanded;
  final bool isGodmode;

  @override
  Widget build(BuildContext context) {
    final bgColor = isGodmode ? GodmodeColors.accent : AppColors.red;
    final textColor = Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: bgColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'LEKTUERE · TAG $days',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
            size: 14,
            color: textColor,
          ),
        ],
      ),
    );
  }
}
