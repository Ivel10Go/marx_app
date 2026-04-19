import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

class CountdownDisplay extends StatelessWidget {
  const CountdownDisplay({required this.seconds, super.key});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final isUrgent = seconds < 5;
    final safeSeconds = seconds.clamp(0, 99);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isUrgent ? const Color(0xFFF6DEDB) : AppColors.paperDark,
        border: Border.all(
          color: isUrgent ? AppColors.red : AppColors.ink,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'ZEIT',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: isUrgent ? AppColors.red : AppColors.inkLight,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '00:${safeSeconds.toString().padLeft(2, '0')}',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isUrgent ? AppColors.red : AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
