import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({required this.days, super.key});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.red,
        border: Border.all(color: AppColors.red, width: 1),
      ),
      child: Text(
        'LEKTUERE · TAG $days',
        style: GoogleFonts.ibmPlexSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.redOnRed,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
