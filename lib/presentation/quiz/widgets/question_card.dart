import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/quote.dart';

class QüstionCard extends StatelessWidget {
  const QüstionCard({required this.quote, super.key});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(
          left: BorderSide(color: AppColors.ink, width: 1),
          right: BorderSide(color: AppColors.ink, width: 1),
          bottom: BorderSide(color: AppColors.ink, width: 1),
        ),
      ),
      child: Text(
        '„${quote.textDe}“',
        style: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontStyle: FontStyle.italic,
          color: AppColors.ink,
          height: 1.45,
        ),
      ),
    );
  }
}
