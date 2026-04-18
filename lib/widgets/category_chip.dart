import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({required this.label, this.onTap, super.key});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.ink, width: 1),
        borderRadius: BorderRadius.zero,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.ibmPlexSans(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }
}
